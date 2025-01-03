import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:routing_app/utils/secrets.dart';
import 'package:routing_app/widget/sliding_panel2.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class RealTimeSearchMap extends StatefulWidget {
  final String destination;
  final String vehicleType;
  final String fuelType;
  final String age;

  const RealTimeSearchMap(
      {super.key,
      required this.destination,
      required this.age,
      required this.fuelType,
      required this.vehicleType});

  @override
  _RealTimeSearchMapState createState() => _RealTimeSearchMapState();
}

class _RealTimeSearchMapState extends State<RealTimeSearchMap> {

  late GoogleMapController _mapController;
  String city = "";
  LatLng? _currentLocation; // User's current location
  LatLng? _searchedLocation;
  Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  String locationInfo = "";
  String _distance = "";
  String _duration = "";
  double _fuelConsumption = 0;
  // Markers on the map
  double calculateMileage(String vehicleType, String age) {
    // Use nested conditions to assign mileage values
    if (vehicleType == 'Car') {
      if (age == '<1') return 18.0;
      if (age == '2') return 16.0;
      if (age == '3') return 14.0;
      if (age == '4') return 12.0;
      if (age == '>5') return 10.0;
    } else if (vehicleType == 'Bike') {
      if (age == '<1') return 45.0;
      if (age == '2') return 42.0;
      if (age == '3') return 40.0;
      if (age == '4') return 38.0;
      if (age == '>5') return 35.0;
    } else if (vehicleType == 'Cycle') {
      return 0; // Cycles do not have mileage
    } else if (vehicleType == 'Auto') {
      if (age == '<1') return 25.0;
      if (age == '2') return 23.0;
      if (age == '3') return 21.0;
      if (age == '4') return 20.0;
      if (age == '>5') return 18.0;
    }
    return 0; // Default mileage if none matches
  }

  // Fetch user's current location
  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Fetch location details for the user's current location
      if (_currentLocation != null) {
        await _fetchLocationDetails(_currentLocation!);
      }
    } catch (e) {
      debugPrint("Error getting current location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to fetch current location. Please try again."),
        ),
      );
    }
  }


  Future<Map<String, dynamic>> fetchDestinationWeather(LatLng destination) async {
    final weatherApiKey = weatherKey; // Replace with your OpenWeatherMap API key
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${destination.latitude}&lon=${destination.longitude}&appid=$weatherApiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(weatherUrl));
      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);
        return {
          'temperature': weatherData['main']['temp'],
          'description': weatherData['weather'][0]['description'],
          'location': weatherData['name']
        };
      } else {
        throw Exception('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }


  Future<void> _fetchDistanceAndDuration(
      LatLng source, LatLng destination) async {
    final apiKey =
        'AIzaSyBx827KsGam_YfYb7ucls9iYpAWwXJk9PM'; // Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${source.latitude},${source.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['rows'] != null &&
            data['rows'].isNotEmpty) {
          final elements = data['rows'][0]['elements'][0];

          if (elements['status'] == 'OK') {
            final distance = elements['distance']['text']; // e.g., "5.4 km"
            final duration = elements['duration']['text']; // e.g., "12 mins"
            final distanceValue = elements['distance']['value'] / 1000;

            final mileage = calculateMileage(widget.vehicleType, widget.age);
            final fuelConsumption = distanceValue / mileage;

            setState(() {
              _distance = distance;
              _duration = duration;
              _fuelConsumption = fuelConsumption;
            });
          } else {
            debugPrint('Error in Distance Matrix API response.');
          }
        } else {
          debugPrint('No results found for Distance Matrix.');
        }
      } else {
        debugPrint(
            'Failed to fetch distance and duration: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching distance and duration: $e');
    }
  }

  // Fetch location details using Geocoding API
  Future<void> _fetchLocationDetails(LatLng location) async {
    final apiKey = googleApiKey;// Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final placeDetails = data['results'][0]; // Top result
          final address = placeDetails['formatted_address'];

          final addressComponents = placeDetails['address_components'];
          for (var component in addressComponents) {
            if (component['types'].contains('locality')) {
              city = component['long_name']; // City name
              break;
            }
          }
          debugPrint(city);

          setState(() {
            locationInfo = address;
          });
        } else {
          debugPrint('No results found for the location.');
        }
      } else {
        debugPrint('Failed to fetch location details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching location details: $e');
    }
  }

  // Add a marker to the map
  void _addMarker(LatLng position, String title) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: position,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }
  // For LatLng



  // Update map to searched location
  Future<void> _updateMapLocation(String address) async {
    try {
      // Get the coordinates of the searched location
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        setState(() {
          _searchedLocation = LatLng(location.latitude, location.longitude);
        });

        // Animate the camera to the searched location
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _searchedLocation!,
              zoom: 15.0,
            ),
          ),
        );

        if (_currentLocation != null && _searchedLocation != null) {
          await _fetchDistanceAndDuration(
              _currentLocation!, _searchedLocation!);
        }

        // Fetch location details for the searched location
        if (_searchedLocation != null) {
          await _fetchLocationDetails(_searchedLocation!);
          _addMarker(_searchedLocation!, "Searched Location");
        }

        // Fetch and display the route
        if (_currentLocation != null && _searchedLocation != null) {
          await _drawRoute(_currentLocation!, _searchedLocation!);
        }
      }
    } catch (e) {
      debugPrint("Error finding location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location not found. Try again."),
        ),
      );
    }
  }

  // Fetch and draw the route
  Future<void> _drawRoute(LatLng source, LatLng destination) async {
    try {
      final String url =
          'http://router.project-osrm.org/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> coordinates =
            data['routes'][0]['geometry']['coordinates'];

        // Convert the route's coordinates into a list of LatLng points
        List<LatLng> polylineCoordinates =
            coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

        // Add the polyline to the map
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      } else {
        throw Exception("Failed to fetch route");
      }
    } catch (e) {
      debugPrint("Error fetching route: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch route. Try again."),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the user's current location when the app starts
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text("Routes")),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SlidingUpPanel(
                  panelBuilder: (controller) => SlidingPanel2(
                    controller: controller,
                    locInfo: locationInfo,
                    dis: _distance,
                    dur: _duration,
                    vehicleType: widget.vehicleType,
                    fuelType: widget.fuelType,
                    age: widget.age,
                    cost: 0,
                    fuelConsumption:
                        _fuelConsumption, // Add the required cost argument
                  ),
                  maxHeight: MediaQuery.of(context).size.height * 0.76,
                  minHeight: MediaQuery.of(context).size.height * 0.09,
                  borderRadius: BorderRadius.circular(12),
                  body: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 12.0,
                    ),
                    onMapCreated: (GoogleMapController controller){
                      _mapController = controller;
                      _updateMapLocation(widget.destination);
                    },
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    markers: _markers,
                    polylines: _polylines,
                  ),
                ),
              ],
            ),
    );
  }
}

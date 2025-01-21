import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:routing_app/pages/profile_page.dart';
import 'package:routing_app/utils/secrets.dart';
import 'package:routing_app/widget/sliding_panel2.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:routing_app/pages/TrafficIncidentsPage.dart';

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
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng? _currentLocation; // User's current location
  LatLng? _searchedLocation;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  bool _showTraffic = false; // Traffic layer toggle
  String locationInfo = "";
  String _SourceOrigin = "";
  String _distance = "";
  String _duration = "";
  Map<String, dynamic> weatherData = {};
  double _fuelConsumption = 0;
  int distance1 = 0;
  double? _placeRating;

  double calculateMileage(String vehicleType, String age) {
    if (vehicleType == 'Car') {
      if (age == '1') return 18;
      if (age == '2') return 17;
      if (age == '3') return 15;
      if (age == '4') return 14;
      if (age == '5') return 13;
      if (age == '6') return 12;
      if (age == '7') return 11;
      if (age == '8') return 10;
      if (age == '9') return 9;
      if (age == '10') return 8;
    } else if (vehicleType == 'Motorcycle') {
      if (age == '1') return 45;
      if (age == '2') return 42;
      if (age == '3') return 40;
      if (age == '4') return 38;
      if (age == '5') return 35;
      if (age == '6') return 33;
      if (age == '7') return 31;
      if (age == '8') return 28;
      if (age == '9') return 25;
      if (age == '10') return 23;
    } else if (vehicleType == 'Truck') {
      if (age == '1') return 15;
      if (age == '2') return 14;
      if (age == '3') return 13;
      if (age == '4') return 12;
      if (age == '5') return 10;
      if (age == '6') return 9;
      if (age == '7') return 8;
      if (age == '8') return 7;
      if (age == '9') return 6;
      if (age == '10') return 5;
    } else if (vehicleType == 'Bus') {
      if (age == '1') return 10;
      if (age == '2') return 9;
      if (age == '3') return 9;
      if (age == '4') return 8;
      if (age == '5') return 7;
      if (age == '6') return 6;
      if (age == '7') return 5;
      if (age == '8') return 4;
      if (age == '9') return 4;
      if (age == '10') return 3;
    }
    return 0;
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
        const SnackBar(
          content: Text("Unable to fetch current location. Please try again."),
        ),
      );
    }
  }

  Future<void> _fetchDistanceAndDuration(
      LatLng source, LatLng destination) async {
    const apiKey = googleApiKey; // Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${source.latitude},${source.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response Data for source: $data');

        if (data['status'] == 'OK' &&
            data['rows'] != null &&
            data['rows'].isNotEmpty) {
          final elements = data['rows'][0]['elements'][0];
          if (data['origin_addresses'] != null &&
              data['origin_addresses'].isNotEmpty) {
            // Get the first origin address
            setState(() {
              _SourceOrigin = data['origin_addresses'][0];
            });
            print('Origin Address: $_SourceOrigin');
          }
          if (elements['status'] == 'OK') {
            final distance = elements['distance']['text']; // e.g., "5.4 km"
            final duration = elements['duration']['text']; // e.g., "12 mins"
            final distanceValue = elements['distance']['value'] / 1000;

            final mileage = calculateMileage(widget.vehicleType, widget.age);
            final fuelConsumption = distanceValue / mileage;

            setState(() {
              _distance = distance;
              _duration = duration;
              distance1 = distanceValue.toInt();
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
    const apiKey = googleApiKey; // Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final placeDetails = data['results'][0]; // Top result
          final address = placeDetails['formatted_address']; // Full address

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

        if (_searchedLocation != null) {
          weatherData = await getWeatherDetails(_searchedLocation!);
        }

        if (_searchedLocation != null) {
          // Fetch place rating
          final placeId = await _getPlaceIdFromLocation(_searchedLocation!);
          if (placeId != null) {
            final rating = await _fetchPlaceRating(placeId);
            setState(() {
              _placeRating = rating;
            });
          }
        }

        // Fetch and display the route
        if (_currentLocation != null && _searchedLocation != null) {
          await _drawRoute(_currentLocation!, _searchedLocation!);
        }
      }
    } catch (e) {
      debugPrint("Error finding location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
              polylineId: const PolylineId('route'),
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
        const SnackBar(
          content: Text("Failed to fetch route. Try again."),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> getWeatherDetails(LatLng location) async {
    const String apiKey =
        weatherKey; // Replace with your OpenWeatherMap API key
    final String url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract necessary details

        return data;
      } else {
        throw Exception("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error fetching weather details: $error");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchTrafficIncidents() async {
    const String apiKey = trafficKey; // Replace with your API key
    if (_currentLocation == null) return [];
    final bbox = calculateBoundingBox(_currentLocation!, _searchedLocation!);
    final String url =
        'https://api.tomtom.com/traffic/services/5/incidentDetails?key=$apiKey&bbox=${_currentLocation!.longitude},${_currentLocation!.latitude},${_searchedLocation!.longitude},${_searchedLocation!.latitude}&fields={incidents{type,geometry{type,coordinates},properties{iconCategory}}}&language=en-GB&t=1111&timeValidityFilter=present';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final incidents = data['incidents'] as List<dynamic>;
        return incidents
            .map((incident) => incident as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to fetch traffic incidents');
      }
    } catch (e) {
      debugPrint('Error fetching traffic incidents: $e');
      return [];
    }
  }

  Future<void> _addTrafficIncidentMarkers(
      List<Map<String, dynamic>> incidents) async {
    Set<Marker> trafficMarkers = {};
    // Load the custom icon
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
          size: Size(24, 24), devicePixelRatio: 1), // Adjust the size if needed
      'assets/images/incident_icon.png', // Path to your custom icon
    );

    for (var i = 0; i < incidents.length; i++) {
      final incident = incidents[i];
      final coordinates = incident['geometry']['coordinates'] as List<dynamic>;

      // Add a marker for each incident's first coordinate
      if (coordinates.isNotEmpty) {
        final LatLng position =
            LatLng(coordinates[0][1], coordinates[0][0]); // Lat, Long
        trafficMarkers.add(
          Marker(
            markerId: MarkerId('traffic_incident_$i'),
            position: position,
            infoWindow: InfoWindow(
              title: "Traffic Incident",
              snippet:
                  "Type: ${incident['type']} | Icon: ${incident['properties']['iconCategory']}",
            ),
            icon:
                customIcon, // Use the custom icon for traffic incidents (optional)
          ),
        );
      }
    }

    setState(() {
      _markers.addAll(trafficMarkers); // Add incident markers to map markers
    });
  }

  String calculateBoundingBox(LatLng source, LatLng destination) {
    double minLat = source.latitude < destination.latitude
        ? source.latitude
        : destination.latitude;
    double maxLat = source.latitude > destination.latitude
        ? source.latitude
        : destination.latitude;
    double minLng = source.longitude < destination.longitude
        ? source.longitude
        : destination.longitude;
    double maxLng = source.longitude > destination.longitude
        ? source.longitude
        : destination.longitude;

    // Expand the bbox slightly to include nearby areas
    const double padding = 0.01; // Adjust padding as needed
    minLat -= padding;
    maxLat += padding;
    minLng -= padding;
    maxLng += padding;

    return "$minLng,$minLat,$maxLng,$maxLat"; // bbox format: "minLng,minLat,maxLng,maxLat"
  }

  Future<double?> _fetchPlaceRating(String placeId) async {
    const apiKey = googleApiKey; // Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['result'] != null) {
          final rating = data['result']['rating'];
          return rating?.toDouble();
        } else {
          debugPrint('No results found for the place.');
          return null;
        }
      } else {
        debugPrint('Failed to fetch place details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching place details: $e');
      return null;
    }
  }

  Future<String?> _getPlaceIdFromLocation(LatLng location) async {
    const apiKey = googleApiKey; // Replace with your API key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final placeId = data['results'][0]['place_id'];
          debugPrint('Place ID: $placeId');
          return placeId;
        } else {
          debugPrint('No results found for the location.');
          return null;
        }
      } else {
        debugPrint('Failed to fetch place ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching place ID: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the user's current location when the app starts
    _getCurrentLocation();
    randomColor = _generateRandomColor();
  }

  String user = 'NA';
  Color? randomColor;

  Future<String?> fetchNameByUid(String uid) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userInfo')
        .where('userid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final String name =
          querySnapshot.docs.first['name']; // Get the 'name' field
      return name;
    } else {
      return null; // No matching documents found
    }
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // Fully opaque
      random.nextInt(256), // Red (0-255)
      random.nextInt(256), // Green (0-255)
      random.nextInt(256), // Blue (0-255)
    );
  }

  void getUserName() async {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;
    final String? name = await fetchNameByUid(currentUid);
    user = name!;
  }

  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    getUserName();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routes"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                icon: CircleAvatar(
                  backgroundColor: randomColor,
                  child: Text(user[0].toUpperCase(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                )),
          )
        ],
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SlidingUpPanel(
                  controller: panelController,
                  panelBuilder: (controller) => SlidingPanel2(
                    panelController: panelController,
                    controller: controller,
                    destination: weatherData,
                    distanceint: distance1,
                    locInfo: locationInfo,
                    dis: _distance,
                    source: _SourceOrigin,
                    dur: _duration,
                    vehicleType: widget.vehicleType,
                    fuelType: widget.fuelType,
                    age: widget.age,
                    cost: 0,
                    fuelConsumption:
                        _fuelConsumption, // Add the required cost argument
                    desti: _searchedLocation,
                    placeRating: _placeRating, // Pass the rating
                  ),
                  maxHeight: MediaQuery.of(context).size.height * 0.76,
                  minHeight: MediaQuery.of(context).size.height * 0.25,
                  borderRadius: BorderRadius.circular(12),
                  body: Stack(children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation!,
                        zoom: 12.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        _updateMapLocation(widget.destination);
                      },
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      markers: _markers,
                      polylines: _polylines,
                      trafficEnabled: _showTraffic, // Enable traffic layer
                    ),
                    Positioned(
                      top: 130,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: () async {
                          final incidents = await _fetchTrafficIncidents();
                          if (incidents.isNotEmpty) {
                            await _addTrafficIncidentMarkers(incidents);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "${incidents.length} traffic incidents displayed on map.")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("No traffic incidents found.")),
                            );
                          }
                        },
                        tooltip: "View Traffic Incidents",
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _showTraffic =
                                !_showTraffic; // Toggle traffic layer
                          });
                        },
                        tooltip: _showTraffic
                            ? "Hide Traffic Layer"
                            : "Show Traffic Layer",
                        child: Icon(
                          _showTraffic ? Icons.traffic : Icons.traffic_outlined,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }

  // Fetch traffic incidents from TomTom API
}

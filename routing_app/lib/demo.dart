import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RealTimeSearchMap extends StatefulWidget {
  @override
  _RealTimeSearchMapState createState() => _RealTimeSearchMapState();
}

class _RealTimeSearchMapState extends State<RealTimeSearchMap> {
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(19.8758, 75.3393); // Default: Aurangabad
  LatLng? _searchedLocation;
  LatLng? _currentLocation;
  Set<Polyline> _polylines = {};

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
        final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

        // Convert the route's coordinates into a list of LatLng points
        List<LatLng> polylineCoordinates = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();

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

    // Set the initial location as the current location
    _currentLocation = _initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-Time Search Map")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _searchedLocation != null
                ? {
                    Marker(
                      markerId: MarkerId("searchedLocation"),
                      position: _searchedLocation!,
                      infoWindow: InfoWindow(title: "Searched Location"),
                    ),
                  }
                : {},
            polylines: _polylines,
          ),
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Enter address",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _updateMapLocation(_searchController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

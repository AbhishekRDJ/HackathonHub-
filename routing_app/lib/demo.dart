import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class RealTimeSearchMap extends StatefulWidget {
  @override
  _RealTimeSearchMapState createState() => _RealTimeSearchMapState();
}

class _RealTimeSearchMapState extends State<RealTimeSearchMap> {
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(37.7749, -122.4194); // Default: San Francisco
  LatLng? _searchedLocation;

  // Update map to searched location
  Future<void> _updateMapLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        setState(() {
          _searchedLocation = LatLng(location.latitude, location.longitude);
        });

        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _searchedLocation!,
              zoom: 15.0,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("${locationFromAddress(_searchController.text)}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location not found. Try again."),
        ),
      );
    }
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


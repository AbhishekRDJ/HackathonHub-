import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:routing_app/widget/sliding_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final locationController = Location();
  final currentLoc = LatLng(19.8758,75.3393);

  LatLng? currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await fetchLocationUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: currentPosition == null ?
          const Center(child: CircularProgressIndicator(),):
      SlidingUpPanel(
        panelBuilder: (controller)=>PanelWidget(controller: controller),
        maxHeight: MediaQuery.of(context).size.height*0.9,
        minHeight: MediaQuery.of(context).size.height*0.06,
        borderRadius: BorderRadius.circular(18),

        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLoc, // Example: San Francisco
            zoom: 10,
          ),
          markers: {
            Marker(
                markerId: const MarkerId('current location'),
              icon: BitmapDescriptor.defaultMarker,
              position: currentPosition!
            )
          },
          onMapCreated: (GoogleMapController controller) {
            // Optional: Handle the map controller
          },
        ),
      )
    );
  }

  Future<void> fetchLocationUpdate() async{
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if(serviceEnabled){
      serviceEnabled = await locationController.requestService();
    }
    else{
      return;
    }
    permissionGranted = await locationController.hasPermission();
    if(permissionGranted == PermissionStatus.denied){
      permissionGranted = await locationController.requestPermission();
    }
    if(permissionGranted!= PermissionStatus.granted){
      return;
    }
    locationController.onLocationChanged.listen((currentLocation){
      if(currentLocation.latitude!=null &&
      currentLocation.longitude!=null){
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!
          );
        });
      }
    });
  }
}

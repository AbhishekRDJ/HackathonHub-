import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:routing_app/pages/profile_page.dart';
import 'package:routing_app/widget/sliding_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final locationController = Location();
  final currentLoc = const LatLng(19.8758, 75.3393);
  String user = 'NA';

  GoogleMapController? mapController;
  Color? randomColor;
  LatLng? currentPosition;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdate());
    randomColor = _generateRandomColor();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  void getUserName() async {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;
    final String? name = await fetchNameByUid(currentUid);
    user = name!;
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

  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    getUserName();
    return Scaffold(
        appBar: AppBar(
          leading: const Text(""),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SvgPicture.asset(
              'assets/images/logo3.svg',
              width: 200,
              height: 55,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                child: CircleAvatar(
                  backgroundColor: randomColor,
                  child: Text(
                    user[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        body: currentPosition == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SlidingUpPanel(
                controller: panelController,
                panelBuilder: (controller) => PanelWidget(
                  controller: controller,
                  panelController: panelController,
                ),
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.2,
                borderRadius: BorderRadius.circular(6),
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLoc, // Example: San Francisco
                    zoom: 12,
                  ),
                  myLocationEnabled:
                      true, // Enable default Google Maps location marker
                  myLocationButtonEnabled:
                      true, // Enable the default location button
                  markers: currentPosition != null
                      ? {
                          Marker(
                            markerId: const MarkerId("searchedLocation"),
                            position: currentPosition!,
                            infoWindow:
                                const InfoWindow(title: "Your Location"),
                          ),
                        }
                      : {},
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      mapController = controller;
                      mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: currentPosition!,
                            zoom: 18,
                          ),
                        ),
                      );
                    });
                  },
                ),
              ));
  }

  Future<void> fetchLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }
}

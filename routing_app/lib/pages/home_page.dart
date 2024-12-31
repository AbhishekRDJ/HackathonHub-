import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  final currentLoc = LatLng(19.8758, 75.3393);

  GoogleMapController? mapController;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentPosition == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SlidingUpPanel(
                panelBuilder: (controller) =>
                    PanelWidget(controller: controller),
                maxHeight: MediaQuery.of(context).size.height * 0.76,
                minHeight: MediaQuery.of(context).size.height * 0.09,
                borderRadius: BorderRadius.circular(6),
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLoc, // Example: San Francisco
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                        markerId: const MarkerId('current location'),
                        icon: BitmapDescriptor.defaultMarker,
                        position: currentPosition!)
                  },
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      mapController = controller;
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

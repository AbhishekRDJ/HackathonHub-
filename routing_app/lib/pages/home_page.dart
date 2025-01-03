import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        appBar: AppBar(
          leading: Text(""),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(
              'assets/images/logo3.svg',
              width: 200,
              height: 55,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(),
            )
          ],
        ),
        body: currentPosition == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SlidingUpPanel(
                panelBuilder: (controller) =>
                    PanelWidget(controller: controller),
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.045,
                borderRadius: BorderRadius.circular(6),
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLoc, // Example: San Francisco
                    zoom: 12,
                  ),
                  myLocationEnabled: true, // Enable default Google Maps location marker
                  myLocationButtonEnabled: true, // Enable the default location button
                  markers: currentPosition != null
                      ? {
                    Marker(
                      markerId: MarkerId("searchedLocation"),
                      position: currentPosition!,
                      infoWindow: InfoWindow(title: "Your Location"),
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

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SlidingUpPanel(
                  panelBuilder: (controller) => _buildPanel(controller),
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  minHeight: MediaQuery.of(context).size.height * 0.06,
                  borderRadius: BorderRadius.circular(18),
                  body: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLoc,
                      zoom: 10,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('current location'),
                        icon: BitmapDescriptor.defaultMarker,
                        position: currentPosition!,
                      )
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'Choose starting point, or click on the map',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
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

  Widget _buildPanel(ScrollController controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'La Jolla Parking Structure',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                RatingBarIndicator(
                  rating: 4.6,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(width: 8),
                const Text(
                  '4.6',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Text(
                  '(3,510)',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHoverButton(Icons.directions, 'Directions', Colors.blue),
                _buildHoverButton(Icons.play_arrow, 'Start', Colors.green),
                _buildHoverButton(Icons.bookmark, 'Save', Colors.orange),
                _buildHoverButton(Icons.share, 'Share', Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Siri Suggestions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnimatedSuggestionCard(),
            const SizedBox(height: 8),
            _buildAnimatedSuggestionCard(),
            const SizedBox(height: 16),
            const Text(
              'Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildBarChart(),
            const SizedBox(height: 16),
            const Text(
              'Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Report an Issue
                  },
                  icon: const Icon(Icons.report),
                  label: const Text('Report an issue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Add to Favorites
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Add to Favorites'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoverButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Add button functionality here
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            // Trigger hover effects if needed
          });
        },
        onExit: (event) {
          setState(() {
            // Remove hover effects
          });
        },
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSuggestionCard() {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(Icons.directions_car, color: Colors.blue),
          title: const Text('Parked Car'),
          subtitle: const Text('290 m away, near ulica Krasnoarmejska'),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Traffic Analysis',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(12, (index) {
                final isPeak = index == 6;
                return Container(
                  width: 16,
                  height: (index + 1) * 10.0,
                  decoration: BoxDecoration(
                    color: isPeak ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
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

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SlidingPanel2 extends StatefulWidget {
  final ScrollController controller;
  final String locInfo;
  final String dis;
  final String dur;
  final String vehicleType;
  final String fuelType;
  final String age;
  final int cost;
  final double fuelConsumption;

  const SlidingPanel2({
    super.key,
    required this.controller,
    required this.dis,
    required this.dur,
    required this.locInfo,
    required this.age,
    required this.fuelType,
    required this.vehicleType,
    required this.cost,
    required this.fuelConsumption,
  });

  @override
  State<SlidingPanel2> createState() => _SlidingPanel2State();
}

class _SlidingPanel2State extends State<SlidingPanel2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  double calculateMileage(String vehicleType, String age) {
    // Use nested conditions to assign mileage values
    if (vehicleType == 'Car') {
      if (age == '<1') return 18;
      if (age == '2') return 16;
      if (age == '3') return 14;
      if (age == '4') return 12;
      if (age == '>5') return 10;
    } else if (vehicleType == 'Bike') {
      if (age == '<1') return 45;
      if (age == '2') return 42;
      if (age == '3') return 40;
      if (age == '4') return 38;
      if (age == '>5') return 35;
    } else if (vehicleType == 'Cycle') {
      return 0; // Cycles do not have mileage
    } else if (vehicleType == 'Auto') {
      if (age == '<1') return 25;
      if (age == '2') return 23;
      if (age == '3') return 21;
      if (age == '4') return 20;
      if (age == '>5') return 18;
    }
    return 0; // Default mileage if none matches
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
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
            Text(
              widget.locInfo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            // New Section for "7 minutes"
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Fuel consumption for your vehicle: ${widget.vehicleType}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.vehicleType == "Cycle"
                        ? "Cycles do not consume fuel."
                        // : "Estimated fuel consumption: ${(double.tryParse(widget.newdist) ?? 0 / (calculateMileage(widget.vehicleType, widget.age) > 0 ? calculateMileage(widget.vehicleType, widget.age) : 1)).toStringAsFixed(2)} liters",
                        : widget.fuelConsumption.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Estimated distance:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.dis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Estimated duration:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.dur,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Your vehicle: ${widget.vehicleType}\n"
              "Your fuel type: ${widget.fuelType}\n"
              "Vehicle age: ${widget.age} years",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBarChart(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle AQI estimation
                  },
                  icon: const Icon(Icons.report),
                  label: const Text('AQI Estimate'),
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
            const SizedBox(height: 16),
            _buildGeminiSuggestions(),
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
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
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
            offset: const Offset(0, 2),
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

  Widget _buildGeminiSuggestions() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _animationController.value) * 20),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Here's Gemini's advice based on your input.",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

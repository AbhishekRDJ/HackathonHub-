import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routing_app/widget/custom_container.dart';

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

  List<int> aqiData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _fetchAQIData();
  }

  Future<void> _fetchAQIData() async {
    const String token = "c2462c6c46be8a23f08c47b110d493265397d745"; // Replace with your API token
    const double latitude = 26.268249; // Replace with actual latitude
    const double longitude = 73.0193853; // Replace with actual longitude

    final String url =
        "https://api.waqi.info/feed/geo:$latitude;$longitude/?token=$token";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "ok") {
          final forecast = data["data"]["forecast"]["daily"]["pm25"];
          setState(() {
            aqiData = forecast.map<int>((item) => item["avg"] as int).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data["data"]["message"] ?? "Unknown error";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch AQI data.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
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
                width: 50,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),
            
            

            const SizedBox(height: 20),
            Text(
              widget.locInfo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHoverButton(Icons.directions, 'Directions', Colors.blue),
                _buildHoverButton(Icons.play_arrow, 'Start', Colors.green),
                _buildHoverButton(Icons.bookmark, 'Save', Colors.orange),
                _buildHoverButton(Icons.share, 'Share', Colors.red),
              ],
            ),
            const SizedBox(height: 20),

            CustomContainer(data1: "Estimated fuel consumption",
                data2: widget.vehicleType == "Cycle"
                    ? "Cycles do not consume fuel."
                    : "${widget.fuelConsumption.toStringAsFixed(2)} liters"),

            const SizedBox(height: 20),
            const Text(
              "Estimated distance:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.dis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            const Text(
              "Estimated duration:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.dur,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomContainer(data1: "vehicle type", data2: widget.vehicleType),
                CustomContainer(data1: "fuel type", data2: widget.fuelType),
                CustomContainer(data1: "Age", data2: widget.age)
              ],
            ),



            const SizedBox(height: 8),
            _buildBarChart(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  SizedBox(height: 8),
                  Text(
                    widget.vehicleType == "Cycle"
                        ? "Cycles do not consume fuel."
                        // : "Estimated fuel consumption: ${(double.tryParse(widget.newdist) ?? 0 / (calculateMileage(widget.vehicleType, widget.age) > 0 ? calculateMileage(widget.vehicleType, widget.age) : 1)).toStringAsFixed(2)} liters",
                        // : widget.fuelConsumption.toString(),
                        : (widget.fuelType == "Petrol")
                          ? "Your emission are: ${(widget.fuelConsumption * 2.31).toStringAsFixed(2)} kg of CO2"
                          : (widget.fuelType == "Diesel")
                          ? "Your emission are: ${(widget.fuelConsumption * 2.68).toStringAsFixed(2)} kg of CO2"
                          : (widget.fuelType == "CNG")
                          ? "Your emission are: ${(widget.fuelConsumption * 1.52).toStringAsFixed(2)} kg of CO2"
                          : (widget.fuelType == "Electric")
                          ? "Your emission are: ${(widget.fuelConsumption * 0.0).toStringAsFixed(2)} kg of CO2"
                          : "Your emission are: ${(widget.fuelConsumption * 2.31).toStringAsFixed(2)} kg of CO2",
                    style: TextStyle(fontSize: 16),
                  ),

                ],
              ),

              
            ),

             const SizedBox(height: 8),
            _buildAQIGraph(),

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
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Add to Favorites
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Add to Favorites'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildGeminiSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAQIGraph() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      );
    }

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
            'Air Quality Index (AQI)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(aqiData.length, (index) {
                final aqiValue = aqiData[index];
                final color = _getAQIColor(aqiValue);

                return Container(
                  width: 16,
                  height: aqiValue.toDouble(),
                  decoration: BoxDecoration(
                    color: color,
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

  Color _getAQIColor(int aqi) {
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi <= 100) {
      return Colors.yellow;
    } else if (aqi <= 150) {
      return Colors.orange;
    } else if (aqi <= 200) {
      return Colors.red;
    } else {
      return Colors.purple;
    }
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
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

import 'dart:math';

import 'bar_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:routing_app/widget/hourly_forcaste.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanel2 extends StatefulWidget {
  final ScrollController controller;
  final int distanceint;
  final PanelController panelController;
  final String locInfo;
  final String dis;
  final String dur;
  final String vehicleType;
  final String fuelType;
  final String age;
  final String source;
  final int cost;
  final double fuelConsumption;
  final Map<String, dynamic> destination;
  final LatLng? desti;
  final double? placeRating;

  const SlidingPanel2({
    super.key,
    required this.distanceint,
    required this.controller,
    required this.panelController,
    required this.destination,
    required this.dis,
    required this.dur,
    required this.locInfo,
    required this.age,
    required this.source,
    required this.fuelType,
    required this.vehicleType,
    required this.cost,
    required this.fuelConsumption,
    required this.desti,
    required this.placeRating,
  });

  @override
  State<SlidingPanel2> createState() => _SlidingPanel2State();
}

class _SlidingPanel2State extends State<SlidingPanel2>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  String _geminiAdvice = "";
  bool aqiColor = false;
  bool carbonColor = false;
  bool isGeminiLoading = false;
  bool isAqiSelected = true;

  Map<String, double> _emissions = {};
  bool showAdvancedLayout = false;
  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
    } else if (vehicleType == 'Bike') {
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

  List<int> aqiData = [];
  List<String> aqiDates = [];
  bool isVisible = false;
  bool isLoading = true;
  bool isLoading2 = true;
  bool isVisible2 = false;
  String errorMessage = '';

  final List<String> _apiKeys = [
    'AIzaSyApOuJrHglGoxym04m2MGb5SIR1Ud53BfA',
    'AIzaSyA1KK-8WxupyjmC3xjj4k1M4-ZUpg--Xcc',
    'AIzaSyB9FXoaNEuzMu9lBFeHnpGTqCkOzxaMm3Q',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeController = AnimationController(
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  String _getRandomApiKey() {
    final random = Random();
    return _apiKeys[random.nextInt(_apiKeys.length)];
  }

  Future<void> _fetchGeminiAdvice() async {
    setState(() {
      isGeminiLoading = true;
    });
    final apiKey = _getRandomApiKey();
    final apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey'; // Replace with your actual API key

    // Constructing the request body with null checks

    final requestBody = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  """Analyze the following travel details and provide two advanced, actionable suggestions within 2 lines. The advice should consider optimizing fuel efficiency, reducing environmental impact, ensuring travel safety, and any other relevant improvements for a smoother and more sustainable journey also it should be only 2 lines max:
- Starting Point: ${widget.source}
- Destination: ${widget.locInfo}"}
- Distance: ${widget.dis} km
- Estimated Duration: ${widget.dur} minutes
- Vehicle Type: ${widget.vehicleType}
- Fuel Type: ${widget.fuelType}
- Vehicle Age: ${widget.age}
- Estimated Fuel Consumption: ${widget.fuelConsumption} liters/100km

Provide advice tailored to the context:
1.If fuel type is gasoline or diesel: Suggest improvements for fuel consumption and emissions.
2.If vehicle type is EV: Recommend optimal charging station stops and battery care tips.
3.For older vehicles: Highlight maintenance tips or precautions for long journeys.
4.Carbon emissions: If data permits, estimate the environmental impact and suggest greener options.

### Format:
- Provide insights in a friendly and engaging tone, suitable for a general audience.
- give only 2 suggestion one in few lines 1-2 only
"""
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          final candidates = data['candidates'] ?? [];
          if (candidates.isNotEmpty) {
            final content = candidates[0]['content'] ?? {};
            final parts = content['parts'] ?? [];
            if (parts.isNotEmpty) {
              _geminiAdvice = parts[0]['text'] ?? 'No advice provided';
            } else {
              _geminiAdvice = 'No parts provided in content.';
            }
          } else {
            _geminiAdvice = 'No candidates provided.';
          }
        });
      } else {
        final errorData = json.decode(response.body);

        setState(() {
          _geminiAdvice = 'Error: ${errorData['error']['message']}';
        });
      }
    } catch (error) {
      setState(() {
        _geminiAdvice = 'Error: $error';
      });
    } finally {
      setState(() {
        isGeminiLoading = false;
      });
    }
  }

  Future<void> _predictEmissions() async {
    final response = await http.post(
      Uri.parse(
          'https://hackathonhub-1-ewui.onrender.com/predict'), // Ensure this is correct
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'vehicle_type': widget.vehicleType,
        'fuel_type': widget.fuelType,
        'vehicle_age': int.parse(widget.age),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _emissions = Map<String, double>.from(json.decode(response.body));
        setState(() {
          isLoading2 = false;
        });
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<void> _fetchAQIData(LatLng desti) async {
    const String token = "c2462c6c46be8a23f08c47b110d493265397d745";

    final String url =
        "https://api.waqi.info/feed/geo:${desti.latitude};${desti.longitude}/?token=$token";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "ok") {
          final forecast = data["data"]["forecast"]["daily"]["pm25"];
          setState(() {
            aqiData = forecast.map<int>((item) => item["avg"] as int).toList();
            aqiDates = forecast.map<String>((item) {
              DateTime date = DateTime.parse(item["day"]);
              return DateFormat("dd/MM").format(date); // Example: 02 Jan 2025
            }).toList();

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
    return GestureDetector(
      onTap: () {},
      child: SingleChildScrollView(
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
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.locInfo,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: widget.placeRating ?? 3.5,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.placeRating != null
                        ? widget.placeRating!.toStringAsFixed(1)
                        : '3.5/5',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildHoverButton(
                      Icons.directions, 'Back on map', Colors.blue, () {
                    widget.panelController.close();
                  }),
                  _buildHoverButton(Icons.bookmark, 'Save', Colors.orange,
                      () async {
                    await FirebaseFirestore.instance.collection("history").add({
                      'location': widget.locInfo,
                      'fule': widget.fuelConsumption.toStringAsFixed(2),
                      'time': widget.distanceint,
                      'vehicle': widget.vehicleType,
                      'fuletype': widget.fuelType,
                      'carbon': _emissions['CO2_emission'] ?? 0,
                      'age': widget.age,
                      'isFav': false,
                      'userid': FirebaseAuth.instance.currentUser!.uid
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("location saved !")));
                  }),
                  _buildHoverButton(Icons.share, 'Share', Colors.red, () {}),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.vehicleType == 'Motorcycle'
                          ? Icons.motorcycle_rounded
                          : widget.vehicleType == 'Car'
                              ? Icons.directions_car
                              : widget.vehicleType == 'Bus'
                                  ? Icons.directions_bus
                                  : Icons.local_shipping,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.dur,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    "Estimated fuel consumption :- ${widget.fuelConsumption.toStringAsFixed(2)} litres",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.energy_savings_leaf,
                    color: Colors.green,
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                child: ListTile(
                  title: Text(widget.vehicleType),
                  subtitle: Text(
                    "Distance :- ${widget.dis}   Fuel type :- ${widget.fuelType},",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      color: Colors.white,
                      size: 33,
                      widget.vehicleType == 'Motorcycle'
                          ? Icons.motorcycle_rounded
                          : widget.vehicleType == 'Car'
                              ? Icons.directions_car
                              : widget.vehicleType == 'Bus'
                                  ? Icons.directions_bus
                                  : Icons.local_shipping,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Weather details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: 120,
                  child: widget.destination.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            final currentSk = widget.destination['list']
                                [index + 1]['weather'][0]['main'];
                            final date = DateTime.parse(widget
                                .destination['list'][index + 1]['dt_txt']);
                            return HourlyForecast(
                                icon: currentSk == 'Clouds' ||
                                        currentSk == 'Rainy'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                time: DateFormat.j().format(date),
                                val:
                                    "${(widget.destination['list'][index + 1]['main']['temp'].toString().substring(0, 2))} °C");
                          }),
                ),
              ),
              // Updated widget code
              const SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    if (!showAdvancedLayout)
                      GestureDetector(
                        onTap: () {
                          _fetchAQIData(widget.desti!);
                          _predictEmissions();

                          setState(() {
                            showAdvancedLayout = true;
                            isVisible = true;
                            _fadeController.forward();
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFDCEAFF),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Show more",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (showAdvancedLayout)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCEAFF),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Stack(
                              children: [
                                AnimatedAlign(
                                  alignment: isAqiSelected
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75 /
                                        2,
                                    height: 45,
                                    margin: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            carbonColor = false;
                                            aqiColor = true;
                                            isVisible = true;
                                            isVisible2 = false;
                                            isAqiSelected = true;
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "AQI Estimate",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: isAqiSelected
                                                  ? Colors.black
                                                  : const Color(0xFF7A7A7A),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isAqiSelected = false;
                                            carbonColor = true;
                                            aqiColor = false;
                                            isVisible = false;
                                            isVisible2 = true;
                                            _predictEmissions();
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "Carbon Emission",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: isAqiSelected
                                                  ? const Color(0xFF7A7A7A)
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Visibility(visible: isVisible, child: _buildAQIGraph()),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: isVisible2,
                  child: BarChartWidget(
                    emissions: _emissions,
                    isLoading: isLoading2,
                  )),

              const SizedBox(height: 25),
              _buildGeminiSuggestions()
            ],
          ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Air Quality Index (AQI)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(aqiData.take(5).length, (index) {
              final aqiValue = aqiData[index];
              final color = _getAQIColor(aqiValue);
              final date = aqiDates[index]; // Fetch date from aqiDates list

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    aqiValue.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 16,
                    height: aqiValue.toDouble(),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              );
            }),
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

  Widget _buildHoverButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient:
                const LinearGradient(colors: [Colors.black12, Colors.black26]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _geminiAdvice = "Fetching suggestions ...";
                _fetchGeminiAdvice();
              });
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/gemini.png"),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Ask suggestion to gemini")
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(_geminiAdvice)
                ],
              ),
            ),
          )),
    );
  }
}

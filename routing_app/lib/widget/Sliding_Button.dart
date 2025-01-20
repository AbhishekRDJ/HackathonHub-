import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SlidingButton(),
    );
  }
}

class SlidingButton extends StatefulWidget {
  @override
  _SlidingButtonState createState() => _SlidingButtonState();
}

class _SlidingButtonState extends State<SlidingButton> {
  bool isAqiSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FA), // Match background color
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20.0), // Equal padding
          child: Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFF), // Light blue background color
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
                    width: 140,
                    height: 45,
                    margin: const EdgeInsets.all(
                        7), // Inner padding for neat spacing
                    decoration: BoxDecoration(
                      color: Colors.white, // Sliding white background
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
                                  : const Color(0xFF7A7A7A), // Grey text color
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
    );
  }
}

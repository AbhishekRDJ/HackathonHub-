import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:routing_app/pages/navigation_page.dart';
import 'package:http/http.dart' as http;

import 'package:routing_app/widget/custome_dropdown.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidget extends StatefulWidget {
  final PanelController panelController;

  final ScrollController controller;
  const PanelWidget(
      {super.key, required this.controller, required this.panelController});

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  final List<String> vehicles = ['Car', 'Motorcycle', 'Truck', 'Bus'];
  final List<String> flue = ['Petrol', 'Diesel'];
  final List<String> age = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  String selectedVehicle = 'Choose vehicle';
  String selectedAge = 'Choose age';
  String selectedFule = 'Choose fuel type';

  String? selectedVehicleType;
  String? selectedFuelType;
  String? _selectedAge;

  TextEditingController controller1 = TextEditingController();

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        controller: widget.controller,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Container(
                width: 32,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Search your destination",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.9, // Adjusted width for responsiveness
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                // Fetch suggestions based on user input
                return await fetchSuggestions(textEditingValue.text);
              },
              displayStringForOption: (String option) => option,
              onSelected: (String selection) {
                _searchController.text =
                    selection; // Set the selected value to the controller
                print(
                    'Selected: $selection'); // Optional: Action after selection
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textController,
                  FocusNode focusNode,
                  VoidCallback onEditingComplete) {
                return TextField(
                  onTap: () {
                    widget.panelController.isPanelOpen
                        ? widget.panelController.close()
                        : widget.panelController.open();
                  },
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(10, 50, 100, 100),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    hintText: "Search",
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Colors.grey),
                    prefixIcon: const Icon(Icons.location_on),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(50, 80, 80, 80)),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(50, 80, 80, 80)),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Select your vehicle",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomeDropdown(
            selectedVehicle: vehicles,
            value: selectedVehicle,
            onChanged: (value) {
              setState(() {
                selectedVehicleType = value;
                selectedVehicle = value!;
                if (selectedVehicle == "Motorcycle") {
                  selectedFuelType = "Petrol";
                }
                if (selectedVehicle == "Truck" || selectedVehicle == "Bus") {
                  selectedFuelType = "Diesel";
                }
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Select your fuel type",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomeDropdown(
            selectedVehicle: flue,
            value: selectedVehicle == 'Motorcycle'
                ? "petrol"
                : selectedVehicle == 'Truck'
                    ? "Diesel"
                    : selectedVehicle == 'Bus'
                        ? "Diesel"
                        : selectedFule,
            onChanged: (value) {
              setState(() {
                selectedFuelType = value;
                selectedFule = selectedVehicle == 'Motorcycle'
                    ? "Petrol"
                    : selectedVehicle == 'Truck'
                        ? "Diesel"
                        : selectedVehicle == 'Bus'
                            ? "Diesel"
                            : value!;
              });
            },
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Enter vehicle age",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomeDropdown(
            selectedVehicle: age,
            value: selectedAge,
            onChanged: (value) {
              setState(() {
                _selectedAge = value;
                selectedAge = value!;
              });
            },
          ),
          const SizedBox(
            height: 25,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text != "" &&
                  selectedVehicleType != null &&
                  selectedFuelType != null &&
                  _selectedAge != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => RealTimeSearchMap(
                            destination: _searchController.text,
                            vehicleType: selectedVehicleType!,
                            fuelType: selectedFuelType!,
                            age: _selectedAge!,
                          )),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("please select all details")));
              }
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black),
              padding:
                  WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
            ),
            child: const Text("Fetch best route",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Future<List<String>> fetchSuggestions(String input) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyBx827KsGam_YfYb7ucls9iYpAWwXJk9PM',
      ),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final predictions = json['predictions'] as List<dynamic>;
      return predictions
          .map<String>((p) => p['description'] as String)
          .toList();
    } else {
      return [];
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:routing_app/pages/navigation_page.dart';
import 'package:http/http.dart' as http;

import 'package:routing_app/widget/custome_dropdown.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  const PanelWidget({super.key,
  required this.controller});

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {

  final List<String> vehicles = ['Car', 'Bike', 'Cycle', 'Auto'];
  final List<String> flue = ['Petrol','Diesel'];
  final List<String> age = ['<1','2','3','4','>=5'];

  String selectedVehicle = 'Choose vehicle';
  String selectedAge = 'Choose age';
  String selectedFule = 'Choose fule type';

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
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
          ),
          const SizedBox(height: 25,),

          const Text("Select your vehicle",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // Adjusted width for responsiveness
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
                _searchController.text = selection; // Set the selected value to the controller
                print('Selected: $selection'); // Optional: Action after selection
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textController, FocusNode focusNode, VoidCallback onEditingComplete) {
                return TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(40, 100, 100, 100),
                    prefixIcon: const Icon(Icons.location_on),
                    filled: true,
                    hintText: 'Search here',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 25,),

          const Text("Select your vehicle",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),

          CustomeDropdown(selectedVehicle: vehicles,
              value: selectedVehicle,
          onChanged: (value) {
            setState(() {
              selectedVehicleType = value;
              selectedVehicle = value!;
            });
          },),

          const SizedBox(height: 30,),

          const Text("Select your fule type",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),

          CustomeDropdown(selectedVehicle: flue,
              value: selectedFule,
            onChanged: (value) {
              setState(() {
                selectedFuelType = value;
                selectedFule = value!;
              });
            },
          ),

          const SizedBox(height: 25,),


          const Text("Enter vehicle age",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),

          CustomeDropdown(selectedVehicle: age,
              value: selectedAge,
          onChanged: (value) {
            setState(() {
              _selectedAge = value;
              selectedAge = value!;
            });
          },),

          const SizedBox(height: 25,),


          const SizedBox(height: 25),
          
          ElevatedButton(onPressed: (){
            if(_searchController.text!=""){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>RealTimeSearchMap(
                    destination: _searchController.text,
                    vehicleType: selectedVehicleType!,
                    fuelType: selectedFuelType!,
                    age: _selectedAge!,
                  )),
              );

            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please select location")));
            }
          },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.lightBlue),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
            ),

            child: const Text("Fetch best route",
                style: TextStyle(
                    fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)
            ),
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
      return predictions.map<String>((p) => p['description'] as String).toList();
    } else {
      return [];
    }
  }
}

import 'package:flutter/material.dart';
import 'package:routing_app/demo.dart';

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
  String selectedVehicle = 'Choose vehicle';
  final List<String> age = ['<1','2','3','4','>=5'];
  String selectedAge = 'Choose age';
  String selectedFule = 'Choose fule type';
  TextEditingController controller1 = TextEditingController();


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
            width: MediaQuery.of(context).size.width*01,
            child: TextField(
              controller: controller1,
              decoration: InputDecoration(
                  fillColor: const Color.fromARGB(40,100, 100, 100),
                  prefixIcon: const Icon(Icons.location_on),
                  filled: true,
                  hintText: 'Search here',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black)
                  )
              ),
            ),
          ),

          const SizedBox(height: 25,),

          const Text("Select your vehicle",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),

          CustomeDropdown(selectedVehicle: vehicles,
              value: selectedVehicle),

          const SizedBox(height: 30,),

          const Text("Select your fule type",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),

          CustomeDropdown(selectedVehicle: flue,
              value: selectedFule),

          const SizedBox(height: 25,),


          const Text("Enter vehicle age",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),

          CustomeDropdown(selectedVehicle: age,
              value: selectedAge),

          const SizedBox(height: 25,),


          const SizedBox(height: 25),
          
          ElevatedButton(onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>RealTimeSearchMap(
                destination: controller1.text,
              ))
            );
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


}

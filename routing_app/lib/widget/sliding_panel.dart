import 'package:flutter/material.dart';
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
  String selectedFule = 'Choose fule type';
  TextEditingController controller1 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        controller: widget.controller,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16)
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

          const Text("Enter your destination",
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

          SizedBox(
            height: MediaQuery.of(context).size.height*0.1,
          ),
          
          ElevatedButton(onPressed: (){

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

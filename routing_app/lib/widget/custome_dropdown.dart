import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomeDropdown extends StatefulWidget {

  final List<String> selectedVehicle;
  String value;

  CustomeDropdown({super.key,
  required this.selectedVehicle,
  required this.value}
  );

  @override
  State<CustomeDropdown> createState() => _CustomeDropdownState();
}

class _CustomeDropdownState extends State<CustomeDropdown> {

  String? val;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color.fromARGB(40, 100, 100, 100),
          border: Border.all()
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: val,
          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
          hint: Text("${widget.value}",
            style:
            TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 16),),
          items: widget.selectedVehicle.map((String vehicle) {
            return DropdownMenuItem<String>(
              value: vehicle,
              child: Text(vehicle),
            );
          }
          ).toList(),
          onChanged: (String? newValue) {
            setState(() {
              val = newValue!;
            }
            );
          },
        ),
      ),
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomeDropdown extends StatefulWidget {
  final List<String> selectedVehicle;
  final ValueChanged<String?> onChanged;
  String value;

  CustomeDropdown(
      {super.key,
      required this.selectedVehicle,
      required this.onChanged,
      required this.value});

  @override
  State<CustomeDropdown> createState() => _CustomeDropdownState();
}

class _CustomeDropdownState extends State<CustomeDropdown> {
  String? val;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color.fromARGB(10, 50, 100, 100),
          border: Border.all(color: const Color.fromARGB(50, 80, 80, 80))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: val,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          hint: Text(
            widget.value,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          items: widget.selectedVehicle.map((String vehicle) {
            return DropdownMenuItem<String>(
              value: vehicle,
              child: Text(vehicle),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

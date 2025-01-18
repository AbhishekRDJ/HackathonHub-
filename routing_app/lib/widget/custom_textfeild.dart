import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String text;
  final Color color;
  final IconData? icon;
  final IconData? preIcon;
  final bool isIcon;
  final bool isPreIcon;
  final TextEditingController? controller;


  const CustomTextField({super.key,
    required this.text,
    required this.color,
    this.icon,
    this.preIcon,
    required this.isIcon,
    this.controller,
    required this.isPreIcon

  }
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isIcon ? true : false,

      decoration: InputDecoration(
        fillColor: const Color.fromARGB(10, 50, 100, 100),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
        hintText: text,
        hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.grey
        ),
        suffixIcon: isIcon ? Icon(icon) : null,
          prefixIcon: isPreIcon ? Icon(preIcon) : null,

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(50, 80,80,80)),
          borderRadius: BorderRadius.circular(12)
        ),

        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(50, 80,80,80)),
            borderRadius: BorderRadius.circular(12)
        ),
      ),
    );
  }
}

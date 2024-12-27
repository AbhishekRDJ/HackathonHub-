import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  Color textColor;

  CustomButton({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,

        style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll(Size(
            MediaQuery.of(context).size.width*0.9,
            MediaQuery.of(context).size.height*0.07
          )),
          elevation: const WidgetStatePropertyAll(8),
          backgroundColor: WidgetStatePropertyAll(color),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black)
              )
          )
        ),
        
        child: Text(label,
          style: TextStyle(fontSize: 16,color: textColor)));
  }
}

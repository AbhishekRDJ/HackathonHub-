import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final IconData icon;
  final String time;
  final String val;

  const HourlyForecast({super.key,
    required this.icon,
    required this.time,
    required this.val});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 10,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(time,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),),
              const SizedBox(height: 8,),
              Icon(icon,size: 32,color: Colors.blue,),
              const SizedBox(height: 8,),
              Text(val,
              )

            ],
          ),
        ),
      ),
    );
  }
}
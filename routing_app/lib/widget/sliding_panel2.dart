import 'package:flutter/material.dart';

class SlidingPanel2 extends StatefulWidget {
  final ScrollController controller;
  const SlidingPanel2({super.key,
    required this.controller});

  @override
  State<SlidingPanel2> createState() => _SlidingPanel2State();
}

class _SlidingPanel2State extends State<SlidingPanel2> {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:routing_app/screens/mobile_screen.dart';
import 'package:routing_app/screens/web_screen.dart';

class ResonsiveScreen extends StatefulWidget {
  const ResonsiveScreen({super.key});

  @override
  State<ResonsiveScreen> createState() => _ResonsiveScreenState();
}

class _ResonsiveScreenState extends State<ResonsiveScreen> {
  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width>600){
      return const WebScreen();
    }
    return const MobileScreen();
  }
}

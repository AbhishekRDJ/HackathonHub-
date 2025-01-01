import 'package:flutter/material.dart';
import 'package:routing_app/resonsive/resonsive_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neo Route',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'lato',
        useMaterial3: true,
      ),
      home: const ResonsiveScreen()
    );
  }
}




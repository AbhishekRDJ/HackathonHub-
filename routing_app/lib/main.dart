import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routing_app/firebase_options.dart';
import 'package:routing_app/resonsive/resonsive_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home:const ResonsiveScreen()
    );
  }
}




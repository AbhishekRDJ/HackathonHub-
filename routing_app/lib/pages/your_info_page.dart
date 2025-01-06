import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YourInfoPage extends StatelessWidget {
  const YourInfoPage({super.key});

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,                   // Fully opaque
      random.nextInt(256),   // Red (0-255)
      random.nextInt(256),   // Green (0-255)
      random.nextInt(256),   // Blue (0-255)
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text(""),
        title: const Text(
          'History',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF5F7FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('userInfo').where("userid",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context,snapshot) {
            return snapshot.data == null ? const Center(child: CircularProgressIndicator()) :
              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Section
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: _generateRandomColor(),
                        child:
                        Text(snapshot.data!.docs[0].data()['name'].toString()[0].toUpperCase()
                        ,style: const TextStyle(fontSize: 28),),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "${snapshot.data!.docs[0].data()['name']}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Transaction List Header
                  const Text(
                    "Recent Locations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: const Text("Mumbai", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Distance: 150 km | Fuel: 10 L"),

                    onTap: () {
                      // Handle tap action
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: const Text("Pune", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Distance: 120 km | Fuel: 8 L"),

                    onTap: () {
                      // Handle tap action
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: const Text("Nagpur", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Distance: 300 km | Fuel: 20 L"),

                    onTap: () {
                      // Handle tap action
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: const Text("Nashik", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Distance: 180 km | Fuel: 12 L"),

                    onTap: () {
                      // Handle tap action
                    },
                  ),

                ],
              ),
            );
          }
          ),
      ),
    );
  }


}

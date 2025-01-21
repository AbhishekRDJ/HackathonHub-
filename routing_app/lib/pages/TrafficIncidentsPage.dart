import 'package:flutter/material.dart';

class TrafficIncidentsPage extends StatelessWidget {
  final List<Map<String, dynamic>> incidents;

  const TrafficIncidentsPage({super.key, required this.incidents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Traffic Incidents")),
      body: incidents.isEmpty
          ? const Center(child: Text("No traffic incidents found."))
          : ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                final type = incident['type'] ?? 'Unknown';
                final coordinates = incident['geometry']['coordinates'];
                final iconCategory = incident['properties']['iconCategory'];

                return ListTile(
                  leading: const Icon(Icons.traffic, color: Colors.red),
                  title: Text("Type: $type"),
                  subtitle: Text("Coordinates: $coordinates"),
                  trailing: Text("Icon: $iconCategory"),
                );
              },
            ),
    );
  }
}

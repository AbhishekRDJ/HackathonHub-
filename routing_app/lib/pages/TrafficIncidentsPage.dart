import 'package:flutter/material.dart';


class TrafficIncidentsPage extends StatelessWidget {
  final List<Map<String, dynamic>> incidents;

  const TrafficIncidentsPage({Key? key, required this.incidents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Traffic Incidents")),
      body: incidents.isEmpty
          ? Center(child: Text("No traffic incidents found."))
          : ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                final type = incident['type'] ?? 'Unknown';
                final coordinates = incident['geometry']['coordinates'];
                final iconCategory = incident['properties']['iconCategory'];

                return ListTile(
                  leading: Icon(Icons.traffic, color: Colors.red),
                  title: Text("Type: $type"),
                  subtitle: Text("Coordinates: $coordinates"),
                  trailing: Text("Icon: $iconCategory"),
                );
              },
            ),
    );
  }
}

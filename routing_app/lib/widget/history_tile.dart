import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routing_app/pages/navigation_page.dart';

class HistoryTile extends StatefulWidget {
  const HistoryTile({super.key});

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('history')
          .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history),
                SizedBox(width: 8),
                Text(
                  'No history available.',
                  style: AppStyles.noDataText,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data();
            double carbonEmission = data['carbon'];

            return GestureDetector(
              child: Column(
                children: [
                  Dismissible(
                    key: Key(snapshot.data!.docs[index].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppColors.danger,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        FirebaseFirestore.instance
                            .collection('history')
                            .doc(snapshot.data!.docs[index].id)
                            .delete();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.tileBackground,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RealTimeSearchMap(
                                destination: data['location'],
                                age: data['age'],
                                fuelType: data['fuletype'],
                                vehicleType: data['vehicle'],
                              ),
                            ),
                          );
                        },
                        leading: const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.avatarBackground,
                          child: Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          data['location'] ?? 'Unknown location',
                          style: AppStyles.tileTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: "Distance: ",
                                      style: AppStyles.tileSubtitle,
                                      children: [
                                    TextSpan(
                                        text: "${data['time'] ?? 'N/A'} km",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ])),
                              const SizedBox(height: 4),
                              RichText(
                                  text: TextSpan(
                                      text: "Fuel: ",
                                      style: AppStyles.tileSubtitle,
                                      children: [
                                    TextSpan(
                                        text: "${data['fule'] ?? 'N/A'} litres",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ])),
                              const SizedBox(width: 10),
                              RichText(
                                  text: TextSpan(
                                      text: "Carbonfoot print: ",
                                      style: AppStyles.tileSubtitle,
                                      children: [
                                    TextSpan(
                                        text:
                                            "${((carbonEmission * data['time']) / 1000).toString().substring(0, 5)} kg",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ])),
                            ],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.iconColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class AppColors {
  static const Color primary = Colors.blueAccent;
  static const Color danger = Colors.red;
  static const Color tileBackground = Colors.white;
  static const Color avatarBackground = Color(0xFFE6F4FF);
  static const Color iconColor = Colors.grey;
}

class AppStyles {
  static const TextStyle noDataText = TextStyle(
    fontSize: 16,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tileTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle tileSubtitle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );
}

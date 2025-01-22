import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routing_app/pages/navigation_page.dart';

class HistoryTile2 extends StatefulWidget {
  const HistoryTile2({super.key});

  @override
  State<HistoryTile2> createState() => _HistoryTile2State();
}

class _HistoryTile2State extends State<HistoryTile2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('history')
          .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('isFav', isEqualTo: true)
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
                  'No favorites available.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data();
            var data2 = snapshot.data!.docs[index];
            double carbonEmission = data['carbon'];
            bool isClick = data['isFav'];

            return GestureDetector(
              child: Column(
                children: [
                  Dismissible(
                    key: Key(snapshot.data!.docs[index].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.red,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(children: [
                        ListTile(
                          onTap: () {},
                          leading: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFE6F4FF),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.blueAccent,
                            ),
                          ),
                          title: Text(
                            data['location'] ?? 'Unknown location',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
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
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
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
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                        children: [
                                      TextSpan(
                                          text:
                                              "${data['fule'] ?? 'N/A'} litres",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ])),
                                const SizedBox(width: 10),
                                RichText(
                                    text: TextSpan(
                                        text: "Carbonfoot print: ",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                        children: [
                                      TextSpan(
                                          text:
                                              "${((carbonEmission * data['time']) / 1000).toStringAsFixed(2)} kg",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ])),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          bottom: 20,
                          child: IconButton(
                            onPressed: () {
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
                            icon: const Icon(Icons.arrow_forward_ios),
                            color: Colors.grey,
                            iconSize: 22,
                          ),
                        ),
                        Positioned(
                          left: 1,
                          bottom: 80,
                          child: GestureDetector(
                            onTap: () {
                              setState(() async {
                                if (data['isFav'] == true) {
                                  await FirebaseFirestore.instance
                                      .collection('history')
                                      .doc(data2.id)
                                      .update({'isFav': false});
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('history')
                                      .doc(data2.id)
                                      .update({'isFav': true});
                                }
                              });
                            },
                            child: Icon(
                              isClick == true
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: isClick == true ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ]),
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

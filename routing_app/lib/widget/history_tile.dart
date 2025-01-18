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
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('history').where('userid',
    isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),

        builder: (context,snapshot){
        return snapshot.connectionState==ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),) :
            ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                  return GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(30, 100, 100, 100),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: ListTile(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RealTimeSearchMap(
                                  destination: snapshot.data!.docs[index].data()['location'],
                                  age: snapshot.data!.docs[index].data()['age'],
                                  fuelType: snapshot.data!.docs[index].data()['fuletype'],
                                  vehicleType: snapshot.data!.docs[index].data()['vehicle'])
                              )
                              );

                            },
                            leading: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.location_on,color: Colors.red,),
                            ),
                            title: Text("${snapshot.data!.docs[index].data()['location']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,),
                            subtitle: Row(
                              children: [
                                Text("Distance :- ${snapshot.data!.docs[index].data()['time']}"),
                                const SizedBox(width: 20,),
                                Text("Fuel :- ${snapshot.data!.docs[index].data()['fule']}")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),

                      ],
                    ),
                  );
              },
            );
    }
    );
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routing_app/pages/start_screen.dart';
class ProfilePage extends StatefulWidget {

  ProfilePage({super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

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
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.output_outlined),
            onPressed: () {
              showDialog(context: context,
                  builder: (context){
                    return AlertDialog(
                      title: const Text("Are you sure you want to sign out ?"),
                      actions: [
                        TextButton(onPressed: () async{
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const StartScreen()));

                        },
                            child: const Text("Yes",style: TextStyle(color: Colors.red),)),

                        TextButton(onPressed: (){

                          Navigator.of(context).pop();
                        },
                            child: const Text("No",style: TextStyle(color: Colors.blue),))
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('userInfo').where("userid",
        isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
         builder: (context,snapshot) {

           return snapshot.data == null ? Center(child: CircularProgressIndicator(),):
             SingleChildScrollView(

             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 const SizedBox(height: 20),
                 CircleAvatar(
                   radius: 50,
                   backgroundColor: _generateRandomColor(),
                   child: Text(snapshot.data!.docs[0].data()['name'].toString().substring(0,1).toUpperCase(),
                   style: const TextStyle(fontSize: 50,color: Colors.white),)
                 ),
                 const SizedBox(height: 10),
                 Text(

                     "${snapshot.data!.docs[0].data()['name']}",
                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                 ),
                 const SizedBox(height: 10),

                 ProfileDetailCard(
                   title: 'Name',
                   value: '${snapshot.data!.docs[0].data()['name']}',
                   onTap: () {
                     _showEditDialog(
                       context: context,
                       title: 'Name',
                       initialValue: '${snapshot.data!.docs[0].data()['name']}',
                       onSave: (newValue) {
                         setState(() {
                            FirebaseFirestore.instance.collection('userInfo').
                           doc(snapshot.data!.docs[0].id).update({
                              'name':newValue
                            });
                         });
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text("Name updated to $newValue")),
                         );
                       },
                     );
                   },
                 ),
                 ProfileDetailCard(
                   title: 'Email',
                   value: '${snapshot.data!.docs[0].data()['email']}',
                   onTap: () {
                     _showEditDialog(
                       context: context,
                       title: 'Email',
                       initialValue: 'sid@growthx.com',
                       onSave: (newValue) {
                         // Handle email save
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                               content: Text("Email updated to $newValue")),
                         );
                       },
                     );
                   },
                 ),
                 ProfileDetailCard(
                   title: 'Phone Number',
                   value: '${snapshot.data!.docs[0].data()['phone']}',
                   onTap: () {
                     _showEditDialog(
                       context: context,
                       title: 'Phone Number',
                       initialValue: '+91 6952346752',
                       onSave: (newValue) {
                         setState(() {
                           FirebaseFirestore.instance.collection('userInfo').
                           doc(snapshot.data!.docs[0].id).update({
                             'phone':newValue
                           });
                         });
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                               content: Text(
                                   "Phone number updated to $newValue")),
                         );
                       },
                     );
                   },
                 ),
                 ProfileAboutSection(
                   aboutText:
                   '${snapshot.data!.docs[0].data()['about']}',
                   onTap: () {
                     _showEditDialog(
                       context: context,
                       title: 'About',
                       initialValue:
                       '${snapshot.data!.docs[0].data()['about']}',
                       onSave: (newValue) {
                         setState(() {
                           FirebaseFirestore.instance.collection('userInfo').
                           doc(snapshot.data!.docs[0].id).update({
                             'about':newValue
                           });
                         });
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                               content: Text("About updated to $newValue")),
                         );
                       },
                     );
                   },
                 ),
               ],
             ),
           );
        }

         )
    );
  }
}

class ProfileDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const ProfileDetailCard({
    required this.title,
    required this.value,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onTap,
        ),
      ),
    );
  }
}

class ProfileAboutSection extends StatelessWidget {
  final String aboutText;
  final VoidCallback onTap;

  const ProfileAboutSection({
    required this.aboutText,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: const Text('About'),
        subtitle: Text(aboutText),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onTap,
        ),
      ),
    );
  }
}

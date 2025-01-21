import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routing_app/pages/start_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Sign Out"),
                    content: const Text("Are you sure you want to sign out?"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const StartScreen()));
                        },
                        child: const Text("Yes",
                            style: TextStyle(color: Colors.red)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No",
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userInfo')
            .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userDoc = snapshot.data!.docs[0];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: _generateRandomColor(),
                  child: Text(
                    userDoc['name'].toString().substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userDoc['name'],
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 20),
                ProfileDetailCard(
                  title: 'Name',
                  value: userDoc['name'],
                  onTap: () {
                    _showEditDialog(
                      context: context,
                      title: 'Name',
                      initialValue: userDoc['name'],
                      onSave: (newValue) {
                        FirebaseFirestore.instance
                            .collection('userInfo')
                            .doc(userDoc.id)
                            .update({'name': newValue});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Name updated to $newValue")));
                      },
                    );
                  },
                ),
                ProfileDetailCard(
                  title: 'Email',
                  value: userDoc['email'],
                  onTap: () {
                    _showEditDialog(
                      context: context,
                      title: 'Email',
                      initialValue: userDoc['email'],
                      onSave: (newValue) {
                        FirebaseFirestore.instance
                            .collection('userInfo')
                            .doc(userDoc.id)
                            .update({'email': newValue});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Email updated to $newValue")));
                      },
                    );
                  },
                ),
                ProfileDetailCard(
                  title: 'Phone Number',
                  value: userDoc['phone'],
                  onTap: () {
                    _showEditDialog(
                      context: context,
                      title: 'Phone Number',
                      initialValue: userDoc['phone'],
                      onSave: (newValue) {
                        FirebaseFirestore.instance
                            .collection('userInfo')
                            .doc(userDoc.id)
                            .update({'phone': newValue});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Phone updated to $newValue")));
                      },
                    );
                  },
                ),
                ProfileAboutSection(
                  aboutText: userDoc['about'],
                  onTap: () {
                    _showEditDialog(
                      context: context,
                      title: 'About',
                      initialValue: userDoc['about'],
                      onSave: (newValue) {
                        FirebaseFirestore.instance
                            .collection('userInfo')
                            .doc(userDoc.id)
                            .update({'about': newValue});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("About updated to $newValue")));
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.teal),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        title:
            const Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(aboutText),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.teal),
          onPressed: onTap,
        ),
      ),
    );
  }
}

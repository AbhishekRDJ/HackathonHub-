import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: IconButton(
                icon: const Icon(Icons.upload, size: 30),
                onPressed: () {
                  // Handle profile picture upload
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Gayatri',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ProfileDetailCard(
              title: 'Name',
              value: 'Gayatri',
              onTap: () {
                _showEditDialog(
                  context: context,
                  title: 'Name',
                  initialValue: 'Gayatri',
                  onSave: (newValue) {
                    // Handle name save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Name updated to $newValue")),
                    );
                  },
                );
              },
            ),
            ProfileDetailCard(
              title: 'Email',
              value: 'sid@growthx.com',
              onTap: () {
                _showEditDialog(
                  context: context,
                  title: 'Email',
                  initialValue: 'sid@growthx.com',
                  onSave: (newValue) {
                    // Handle email save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email updated to $newValue")),
                    );
                  },
                );
              },
            ),
            ProfileDetailCard(
              title: 'Phone Number',
              value: '+91 6952346752',
              onTap: () {
                _showEditDialog(
                  context: context,
                  title: 'Phone Number',
                  initialValue: '+91 6952346752',
                  onSave: (newValue) {
                    // Handle phone number save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Phone number updated to $newValue")),
                    );
                  },
                );
              },
            ),
            ProfileAboutSection(
              aboutText:
                  'Lorem ipsum dolor sit amet consectetur. Erat auctor a aliquam vel congue luctus.',
              onTap: () {
                _showEditDialog(
                  context: context,
                  title: 'About',
                  initialValue:
                      'Lorem ipsum dolor sit amet consectetur. Erat auctor a aliquam vel congue luctus.',
                  onSave: (newValue) {
                    // Handle about save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("About updated to $newValue")),
                    );
                  },
                );
              },
            ),
          ],
        ),
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

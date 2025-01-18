import 'package:flutter/material.dart';
import 'package:routing_app/pages/home_page.dart';
import 'package:routing_app/pages/profile_page.dart';
import 'package:routing_app/pages/history.dart';

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final pages = [const HomePage(), const YourInfoPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (val) {
            setState(() {
              index = val;
            });
          },
          currentIndex: index,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(color: Colors.black),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          unselectedItemColor: Colors.grey,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ]),
      body: IndexedStack(
        index: index,
        children: pages,
      ),
    );
  }
}

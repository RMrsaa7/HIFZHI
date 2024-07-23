import 'package:flutter/material.dart';
import 'menu/hafalan.dart';
import 'menu/riwayah.dart';
import 'menu/akun.dart';
import 'menu/home.dart'; // Import halaman Beranda
import 'bottom_navigation.dart';

class BerandaScreen extends StatefulWidget {
  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    HafalanPage(),
    RiwayahPage(),
    AkunPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _navigateToHafalanPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HafalanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToHafalanPage,
        child: Icon(Icons.book),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

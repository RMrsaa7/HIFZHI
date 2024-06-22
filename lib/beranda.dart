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
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HafalanPage()),
      ).then((_) => _onReturnToBeranda());
    // } else if (index == 2) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => RiwayahPage()),
    //   ).then((_) => _onReturnToBeranda());
    // } else if (index == 3) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ProfilePage()),
    //   ).then((_) => _onReturnToBeranda());
    }
  }

  void _onReturnToBeranda() {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

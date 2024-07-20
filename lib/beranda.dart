import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'menu/hafalan.dart';
import 'menu/riwayah.dart';
import 'menu/akun.dart';
import 'menu/home.dart';
import 'bottom_navigation.dart';
import 'login.dart';

class BerandaScreen extends StatefulWidget {
  final User user;

  BerandaScreen({required this.user});

  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> setoranList = []; // Inisialisasi dengan data yang sesuai

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(),
      HafalanPage(setoranList: setoranList), // Kirim parameter yang dibutuhkan
      RiwayahPage(setoranList: setoranList), // Kirim parameter yang dibutuhkan
      AkunPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _navigateToHafalanPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HafalanPage(setoranList: setoranList)),
    );
  }

  void _navigateToAkunPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AkunPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda'),
      ),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.displayName ?? 'Pengguna'),
              accountEmail: Text(widget.user.email ?? 'Email tidak tersedia'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.user.email?.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Hafalan'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Riwayah'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Akun'),
              onTap: () {
                _navigateToAkunPage();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), 
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

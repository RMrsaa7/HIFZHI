import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';

class BerandaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(17),
        height: size.width * .150,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.microphone),
                label: 'Hafalan',
              ),
              BottomNavigationBarItem(
                icon: Transform.scale(
                  scale: 0.8,
                  child: Icon(LineIcons.history, size: 32.0),
                ),
                label: 'Riwayat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: 'Akun',
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Content goes here'),
      ),
    );
  }
}

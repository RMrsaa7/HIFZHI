import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomNavigation({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(20),
      height: size.width * .155,
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
      child: ListView.builder(
        itemCount: listOfIcons.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: size.width * .024),
        itemBuilder: (context, index) => InkWell(
          onTap: () => onTap(index),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 700),
                curve: Curves.fastLinearToSlowEaseIn, // Menggunakan Curves.ease
                margin: EdgeInsets.only(
                  bottom: index == currentIndex ? 0 : size.width * .029,
                  right: size.width * .0415,
                  left: size.width * .0415,
                ),
                width: size.width * .125,
                height: index == currentIndex ? size.width * .013 : 0,
                decoration: BoxDecoration(
                  color: Color(0xCC38A6A5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
              ),
              Icon(
                listOfIcons[index],
                size: size.width * .050,
                color: index == currentIndex ? Color(0xCC38A6A5) : Colors.black38,
              ),
              Text(
                listOfLabels[index],
                style: TextStyle(
                  color: index == currentIndex ? Color(0xCC38A6A5) : Colors.black38,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: size.width * .03),
            ],
          ),
        ),
      ),
    );
  }

    final List<IconData> listOfIcons = [
    Iconsax.home,
    Iconsax.microphone,
    Icons.history, // Menggunakan ikon history bawaan Flutter
    Iconsax.user,
  ];

  final List<String> listOfLabels = [
    'Beranda',
    'Hafalan',
    'Riwayat',
    'Akun',
  ];

}

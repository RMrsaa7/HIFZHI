import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailkajian.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List imageList = [
    {"id": 1, "image_path": 'assets/1.jpg'},
    {"id": 2, "image_path": 'assets/2.jpg'},
    {"id": 3, "image_path": 'assets/3.jpg'}
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  User? user = FirebaseAuth.instance.currentUser;
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['username'] ?? 'User';
        });
      }
    }
  }

  List<Map<String, String>> kajianList = [
    {
      "image_path": 'assets/kajian1.jpg',
      "title": "Tabligh Akbar di Masjid Agung",
      "description":
          "[Kajian MUSAWARAH] Kunci Cepat Kebahagiaan Dalam Al-Qur'an Bintaro, 5 November 2022 \n",
      "detail":
          "Bersama Ustad Adi Hidayat, membahas tentang pentingnya ilmu dan bagaimana Al-Qur'an memberikan panduan untuk mencapai kebahagiaan yang sejati dan cepat dalam kehidupan sehari-hari.",
    },
    {
      "image_path": 'assets/kajian2.jpg',
      "title": "Kajian Subuh di Masjid Raya",
      "description":
          "Bersama Ustad Adi Hidayat, membahas tentang kekuatan doa dan dzikir di waktu subuh.",
      "detail":
          "Bersama Ustad Adi Hidayat, membahas tentang kekuatan doa dan dzikir di waktu subuh. Acara ini akan diadakan pada tanggal 31 Juli 2024, pukul 05:00 WIB."
    },
    {
      "image_path": 'assets/kajian3.jpg',
      "title": "Tabligh Akbar di Masjid Agung",
      "description":
          "Bersama Ustad Adi Hidayat, mengupas tuntas tentang tafsir Al-Qur'an dan aplikasinya dalam kehidupan modern.",
      "detail":
          "Bersama Ustad Adi Hidayat, mengupas tuntas tentang tafsir Al-Qur'an dan aplikasinya dalam kehidupan modern. Acara ini akan diadakan pada tanggal 1 Agustus 2024, pukul 08:00 WIB."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tambahkan gambar di bagian paling belakang
          Positioned.fill(
            child: Image.asset(
              'assets/Hero.png', // Sesuaikan dengan path gambar yang benar
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 15, top: 65),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, $userName',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 53, 170, 168),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Ayo Semangat menjadi Ahli Al-Qur\'an!',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/profile.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 13,
                      right: 15,
                      child: IconButton(
                        icon: Icon(Icons.notifications,
                            color: Colors.yellow, size: 28),
                        onPressed: () {
                          // Tambahkan aksi untuk ikon notifikasi di sini
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      print(currentIndex);
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CarouselSlider(
                              items: imageList
                                  .map(
                                    (item) => Image.asset(
                                      item['image_path'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                  .toList(),
                              carouselController: carouselController,
                              options: CarouselOptions(
                                scrollPhysics: const BouncingScrollPhysics(),
                                autoPlay: true,
                                aspectRatio: 2,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imageList.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    carouselController.animateToPage(entry.key),
                                child: Container(
                                  width: currentIndex == entry.key ? 17 : 7,
                                  height: 7.0,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: currentIndex == entry.key
                                        ? const Color.fromARGB(255, 199, 198, 198)
                                        : Colors.teal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Setoran terakhir kamu",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 168, 168, 168),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "27 Maret 2024 08:00 WIB",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 53, 170, 168)),
                        ),
                        Text(
                          "Dari: Al-Fatihah: 1",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Sampai: Al-Baqarah: 2",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 17, right: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Info Kajian",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 168, 168, 168),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: kajianList.map((kajian) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KajianDetailPage(
                                    imagePath: kajian['image_path']!,
                                    title: kajian['title']!,
                                    description: kajian['description']!,
                                    detail: kajian['detail']!,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.asset(
                                    kajian['image_path']!,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    kajian['title']!,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    kajian['description']!,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

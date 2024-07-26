import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailriwayah.dart';

class RiwayahPage extends StatefulWidget {
  @override
  _RiwayahPageState createState() => _RiwayahPageState();
}

class _RiwayahPageState extends State<RiwayahPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String userName = 'Pengguna';

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
          userName = userDoc['username'] ?? 'Pengguna';
        });
      }
    }
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Tanggal tidak tersedia';
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Setoran Selesai',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ini adalah halaman untuk melihat Riwayat Setoran yang telah selesai, Anda dapat mengecek masukan dari Musyrif/Musyrifah dengan memilih hasil setoran yang Anda inginkan',
                    style: GoogleFonts.poppins(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hafalan')
                    .orderBy('tanggal_setoran', descending: true) // Mengurutkan berdasarkan tanggal_setoran terbaru
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var hafalanList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: hafalanList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot hafalan = hafalanList[index];
                      return buildTableRow(
                          context,
                          index + 1,
                          hafalan['surat'] ?? 'Surat tidak tersedia',
                          formatDate(hafalan['tanggal_setoran'] as Timestamp?),
                          hafalan);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTableRow(BuildContext context, int no, String setoran,
      String tglSetor, DocumentSnapshot hafalan) {
    var hafalanData = hafalan.data() as Map<String, dynamic>;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Color.fromARGB(255, 255, 253, 208),
      child: ListTile(
        leading: Text(no.toString(), style: GoogleFonts.poppins()),
        title: Text(setoran, style: GoogleFonts.poppins()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tgl. Setor: $tglSetor', style: GoogleFonts.poppins()),
            Text(
                'Status Hafalan: ${hafalanData.containsKey('status') ? hafalan['status'] : 'Belum dinilai'}',
                style: GoogleFonts.poppins()),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailRiwayahPage(
                        namaPeserta: userName,
                        tanggalSetoran: formatDate(
                            hafalan['tanggal_setoran'] as Timestamp?),
                        tanggalDinilai: formatDate(hafalan['tanggal_dinilai']
                            as Timestamp?), // Ambil tanggal dinilai dari Firestore
                        musyrifDiTempatTinggal: hafalan[
                                'musyrifDiTempatTinggal'] ??
                            'Musyrif di Tempat Tinggal', // Ambil data dinamis dari Firestore
                        surah: hafalan['surat'] ?? 'Surat tidak tersedia',
                        ayat:
                            '${hafalan['ayat_awal'] ?? '0'} - ${hafalan['ayat_akhir'] ?? '0'}',
                        halaman: '-', // Ambil data dinamis dari Firestore
                        juz: hafalan['juz'] ?? 'Juz tidak tersedia',
                        jenisSetoran: hafalan['jenis_setoran'] ??
                            'Jenis setoran tidak tersedia',
                        namaMusyrif: hafalan['namaMusyrif'] ??
                            'Nama Musyrif tidak tersedia', // Ambil data dinamis dari Firestore
                        makhrojulHuruf: hafalan['makhrojulHuruf'] ??
                            0, // Ambil data dinamis dari Firestore
                        hukumTajwid: hafalan['hukumTajwid'] ??
                            0, // Ambil data dinamis dari Firestore
                        hukumMad: hafalan['hukumMad'] ??
                            0, // Ambil data dinamis dari Firestore
                        hukumWaqafIbtida: hafalan['hukumWaqafIbtida'] ??
                            0, // Ambil data dinamis dari Firestore
                        kelancaranHafalan: hafalan['kelancaranHafalan'] ??
                            0, // Ambil data dinamis dari Firestore
                        kualitasHafalan: hafalan['kualitasHafalan'] ??
                            0, // Ambil data dinamis dari Firestore
                        statusHafalan:
                            'Diterima', // Set a default value if needed
                        feedback: hafalan['feedback'] ??
                            'Feedback tidak tersedia', // Ambil data dinamis dari Firestore
                      )),
            );
          },
          child: Text('Detail',
              style:
                  GoogleFonts.poppins(color: Color.fromARGB(255, 255, 174, 0))),
        ),
      ),
    );
  }
}

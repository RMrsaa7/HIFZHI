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
                stream: FirebaseFirestore.instance.collection('hafalan').snapshots(),
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
                          'Diterima', // Asumsi 'Diterima' untuk semua. Anda bisa modifikasi berdasarkan struktur data Anda.
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
      String tglSetor, String status, DocumentSnapshot hafalan) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Color.fromARGB(255, 255, 253, 208),
      child: ListTile(
        leading: Text(no.toString(), style: GoogleFonts.poppins()),
        title: Text(setoran, style: GoogleFonts.poppins()),
        subtitle: Text('Tgl. Setor: $tglSetor\nStatus: $status',
            style: GoogleFonts.poppins()),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailRiwayahPage(
                    namaPeserta: userName,
                    tanggalSetoran: formatDate(hafalan['tanggal_setoran'] as Timestamp?),
                    tanggalDinilai: '31 Mei 2024', // Contoh tanggal, sebaiknya dinamis
                    musyrifDiTempatTinggal: 'Musyrif di Tempat Tinggal', // Contoh data, sebaiknya dinamis
                    surah: hafalan['surat'] ?? 'Surat tidak tersedia',
                    ayat: '${hafalan['ayat_awal'] ?? '0'} - ${hafalan['ayat_akhir'] ?? '0'}',
                    halaman: '596', // Contoh data, sebaiknya dinamis
                    juz: hafalan['juz'] ?? 'Juz tidak tersedia',
                    jenisSetoran: hafalan['jenis_setoran'] ?? 'Jenis setoran tidak tersedia',
                    namaMusyrif: 'Annisa Aulia Rahma', // Contoh data, sebaiknya dinamis
                    makhrojulHuruf: 9, // Contoh data, sebaiknya dinamis
                    hukumTajwid: 9, // Contoh data, sebaiknya dinamis
                    hukumMad: 9, // Contoh data, sebaiknya dinamis
                    hukumWaqafIbtida: 9, // Contoh data, sebaiknya dinamis
                    kelancaranHafalan: 9, // Contoh data, sebaiknya dinamis
                    kualitasHafalan: 9, // Contoh data, sebaiknya dinamis
                    statusHafalan: status,
                    feedback: 'Alhamdulillah bacaan bunda semua sdh baik dan stabil barakallah fikum 👍 tetap semangat menjadi ahli al quran', // Contoh data, sebaiknya dinamis
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

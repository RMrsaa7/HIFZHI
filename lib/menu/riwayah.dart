import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detailriwayah.dart';

class RiwayahPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Setoran Selesai',
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'RADEN MARISSA LESTARI',
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
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildTableRow(
                      context,
                      1,
                      'Surah Adh-Dhuhaa sampai Surah Adh-Dhuhaa Ayat: 1 - 11',
                      '30 Mei 2024',
                      'Diterima'),
                  buildTableRow(
                      context,
                      2,
                      'Surah Al-Lail sampai Surah Al-Lail Ayat: 1 - 5',
                      '06 Agustus 2023',
                      'Diterima'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTableRow(BuildContext context, int no, String setoran,
      String tglSetor, String status) {
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
                    namaPeserta: 'RADEN MARISSA LESTARI',
                    tanggalSetoran: tglSetor,
                    tanggalDinilai: '31 Mei 2024',
                    musyrifDiTempatTinggal: 'Musyrif di Tempat Tinggal',
                    surah: setoran,
                    ayat: '1 - 11',
                    halaman: '596',
                    juz: '30',
                    jenisSetoran: 'ZIYADAH (SETORAN HAFALAN)',
                    namaMusyrif: 'Annisa Aulia Rahma',
                    makhrojulHuruf: 9,
                    hukumTajwid: 9,
                    hukumMad: 9,
                    hukumWaqafIbtida: 9,
                    kelancaranHafalan: 9,
                    kualitasHafalan: 9,
                    statusHafalan: status,
                    feedback: 'Alhamdulillah bacaan bunda semua sdh baik dan stabil barakallah fikum 👍 tetap semangat menjadi ahli al quran',
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

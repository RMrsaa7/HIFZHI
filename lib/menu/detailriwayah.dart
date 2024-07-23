import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRiwayahPage extends StatelessWidget {
  final String namaPeserta;
  final String tanggalSetoran;
  final String tanggalDinilai;
  final String musyrifDiTempatTinggal;
  final String surah;
  final String ayat;
  final String halaman;
  final String juz;
  final String jenisSetoran;
  final String namaMusyrif;
  final int makhrojulHuruf;
  final int hukumTajwid;
  final int hukumMad;
  final int hukumWaqafIbtida;
  final int kelancaranHafalan;
  final int kualitasHafalan;
  final String statusHafalan;
  final String feedback;

  DetailRiwayahPage({
    required this.namaPeserta,
    required this.tanggalSetoran,
    required this.tanggalDinilai,
    required this.musyrifDiTempatTinggal,
    required this.surah,
    required this.ayat,
    required this.halaman,
    required this.juz,
    required this.jenisSetoran,
    required this.namaMusyrif,
    required this.makhrojulHuruf,
    required this.hukumTajwid,
    required this.hukumMad,
    required this.hukumWaqafIbtida,
    required this.kelancaranHafalan,
    required this.kualitasHafalan,
    required this.statusHafalan,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Riwayah',
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailRow('Nama Peserta', namaPeserta),
            buildDetailRow('Tanggal Setoran', tanggalSetoran),
            buildDetailRow('Tanggal Dinilai', tanggalDinilai),
            buildDetailRow('Musyrif di Tempat Tinggal', musyrifDiTempatTinggal),
            SizedBox(height: 16),
            Center(child: buildSectionTitle('Detail Setoran')),
            buildDetailRow('Surat', surah),
            buildDetailRow('Ayat', ayat),
            buildDetailRow('Halaman', halaman),
            buildDetailRow('Juz', juz),
            buildDetailRow('Pilih Jenis Setoran', jenisSetoran),
            SizedBox(height: 16),
            Center(child: buildSectionTitle('Detail Yang Disetorkan')),
            buildDetailRow('Surat', surah),
            buildDetailRow('Ayat', ayat),
            buildDetailRow('Halaman', halaman),
            buildDetailRow('Juz', juz),
            buildDetailRow('Pilih Jenis Setoran', jenisSetoran),
            SizedBox(height: 16),
            Center(child: buildSectionTitle('PENILAIAN DARI MUSYRIF HIFZHI')),
            buildDetailRow('Nama Musyrif', namaMusyrif),
            buildRatingRow('Makhrojul Huruf', makhrojulHuruf),
            buildRatingRow('Hukum Tajwid', hukumTajwid),
            buildRatingRow('Hukum Mad', hukumMad),
            buildRatingRow('Hukum Waqaf Ibtida', hukumWaqafIbtida),
            buildRatingRow('Kelancaran Hafalan', kelancaranHafalan),
            buildRatingRow('Kualitas Hafalan', kualitasHafalan),
            buildDetailRow('Status Hafalan', statusHafalan),
            SizedBox(height: 16),
            Center(child: buildSectionTitle('FEEDBACK UNTUK PESERTA')),
            buildDetailRow('Tulisan Feedback', feedback, isFeedback: true),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value, {bool isFeedback = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment:
            isFeedback ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRatingRow(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  rating.toString(),
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.green,
      width: double.infinity,
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

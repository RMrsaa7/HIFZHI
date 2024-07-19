import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kebijakan Privasi'),
        backgroundColor: Color(0xff2DA2A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kebijakan Privasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Kami sangat menghargai privasi Anda dan berkomitmen untuk melindungi informasi pribadi Anda. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi yang Anda berikan kepada kami melalui aplikasi ini.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              buildSection(
                '1. Informasi yang Kami Kumpulkan',
                'Informasi Pribadi: Saat Anda mendaftar atau menggunakan aplikasi kami, kami mungkin meminta informasi pribadi seperti nama, alamat email, nomor telepon, dan informasi lainnya. Informasi Non-Pribadi: Kami juga dapat mengumpulkan informasi non-pribadi seperti data penggunaan aplikasi, preferensi pengguna, dan informasi teknis lainnya.',
                Icons.info,
              ),
              buildSection(
                '2. Penggunaan Informasi',
                'Kami menggunakan informasi yang dikumpulkan untuk menyediakan, memelihara, dan meningkatkan layanan kami. Kami dapat menggunakan informasi Anda untuk mengirimkan pembaruan, pemberitahuan, atau informasi lain yang mungkin Anda minati.',
                Icons.insert_chart,
              ),
              buildSection(
                '3. Perlindungan Informasi',
                'Kami mengambil langkah-langkah keamanan yang wajar untuk melindungi informasi pribadi Anda dari akses, pengungkapan, atau perusakan yang tidak sah. Kami membatasi akses ke informasi pribadi Anda hanya kepada karyawan atau mitra yang memerlukan akses tersebut untuk menjalankan tugas mereka.',
                Icons.security,
              ),
              buildSection(
                '4. Berbagi Informasi',
                'Kami tidak akan menjual, menyewakan, atau menukar informasi pribadi Anda kepada pihak ketiga tanpa persetujuan Anda, kecuali jika diwajibkan oleh hukum.',
                Icons.share,
              ),
              buildSection(
                '5. Perubahan Kebijakan Privasi',
                'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Kami akan memberitahu Anda tentang perubahan tersebut dengan memposting kebijakan privasi yang diperbarui di aplikasi kami.',
                Icons.update,
              ),
              buildSection(
                '6. Kontak Kami',
                'Jika Anda memiliki pertanyaan atau kekhawatiran tentang kebijakan privasi ini, silakan hubungi kami melalui Instagram di @hifzhi.app.',
                Icons.contact_mail,
              ),
              Text(
                'Dengan menggunakan aplikasi ini, Anda menyetujui pengumpulan dan penggunaan informasi Anda seperti yang dijelaskan dalam kebijakan privasi ini.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, String content, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  content,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

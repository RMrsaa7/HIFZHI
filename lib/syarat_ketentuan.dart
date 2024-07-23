import 'package:flutter/material.dart';

class SyaratKetentuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syarat & Ketentuan'),
        backgroundColor: Color(0xff2DA2A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat & Ketentuan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Penjelasan lengkap mengenai syarat dan ketentuan penggunaan aplikasi...',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              buildSection(
                '1. Penggunaan Aplikasi',
                'Ketentuan tentang bagaimana aplikasi ini dapat digunakan oleh pengguna. Pembatasan dan larangan penggunaan.',
                Icons.app_settings_alt,
              ),
              buildSection(
                '2. Hak dan Kewajiban Pengguna',
                'Informasi mengenai hak-hak pengguna saat menggunakan aplikasi. Kewajiban yang harus dipatuhi oleh pengguna.',
                Icons.account_box,
              ),
              buildSection(
                '3. Pembatasan Tanggung Jawab',
                'Penjelasan tentang pembatasan tanggung jawab dari pihak pengembang aplikasi.',
                Icons.warning,
              ),
              buildSection(
                '4. Perubahan Syarat & Ketentuan',
                'Informasi tentang bagaimana perubahan terhadap syarat dan ketentuan akan diberlakukan.',
                Icons.update,
              ),
              buildSection(
                '5. Kontak Kami',
                'Jika Anda memiliki pertanyaan atau kekhawatiran tentang syarat dan ketentuan ini, silakan hubungi kami melalui Instagram di @hifzhi.app.',
                Icons.contact_mail,
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

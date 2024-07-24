import 'package:flutter/material.dart';

// Model untuk data setoran hafalan
class HafalanSetoran {
  final String namaPeserta;
  final String nomorRegistrasi;
  final String surat;
  final String sampaiSurat;
  final String ayatAwal;
  final String ayatAkhir;
  final String juz;
  final String jenisSetoran;
  final String fileName;

  HafalanSetoran({
    required this.namaPeserta,
    required this.nomorRegistrasi,
    required this.surat,
    required this.sampaiSurat,
    required this.ayatAwal,
    required this.ayatAkhir,
    required this.juz,
    required this.jenisSetoran,
    required this.fileName,
  });
}

class AdminPage extends StatefulWidget {
  final List<HafalanSetoran> setoranList;

  AdminPage({required this.setoranList});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Admin'),
        backgroundColor: Color(0xff2DA2A1),
      ),
      body: ListView.builder(
        itemCount: widget.setoranList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.setoranList[index].namaPeserta),
            subtitle: Text('Surat: ${widget.setoranList[index].surat}, Ayat: ${widget.setoranList[index].ayatAwal}-${widget.setoranList[index].ayatAkhir}'),
            trailing: IconButton(
              icon: Icon(Icons.rate_review),
              onPressed: () {
                // Tindakan untuk memberikan penilaian atau tindakan lainnya
                // Misalnya, menampilkan dialog untuk memberikan nilai
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Penilaian Setoran'),
                    content: Text('Berikan nilai atau tindakan lain untuk setoran ini.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Tambahkan logika untuk memberikan nilai atau tindakan
                        },
                        child: Text('Submit'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HafalanPage(),
    );
  }
}

class HafalanPage extends StatefulWidget {
  @override
  _HafalanPageState createState() => _HafalanPageState();
}

class _HafalanPageState extends State<HafalanPage> {
  // Deklarasi variabel dan method-method lainnya seperti yang telah Anda implementasikan sebelumnya

  List<HafalanSetoran> _setoranList = []; // List untuk menyimpan setoran hafalan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sama seperti sebelumnya, implementasi halaman setoran hafalan
      // Tambahkan tombol atau navigasi untuk menuju halaman admin
      // Misalnya, menggunakan FloatingActionButton atau NavigationDrawer
    );
  }
}

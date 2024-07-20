import 'package:flutter/material.dart';

class RiwayahPage extends StatelessWidget {
  final List<Map<String, dynamic>> setoranList;

  RiwayahPage({required this.setoranList});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    double width = MediaQuery.of(context).size.width;
    double padding = width > 600 ? 20 : 10; // Penyesuaian padding berdasarkan lebar layar
    double fontSize = width > 600 ? 18 : 14; // Penyesuaian ukuran font berdasarkan lebar layar

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Setoran'),
        backgroundColor: Color(0xff2DA2A1),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Text(
              'Riwayat Setoran Selesai',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Ini adalah halaman untuk melihat riwayat setoran yang telah selesai. Anda dapat mengecek masukan dari Musyrif atau Musyrifah dengan memilih hasil setoran yang Anda inginkan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize - 2, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(padding),
              color: Colors.yellow[100],
              child: Text(
                'Pilih setoran di bawah ini untuk melihat lebih detail',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize - 4, color: Colors.black87),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: width / 20, // Penyesuaian spacing berdasarkan lebar layar
                columns: [
                  DataColumn(label: Text('No', style: TextStyle(fontSize: fontSize - 4))),
                  DataColumn(label: Text('Setoran', style: TextStyle(fontSize: fontSize - 4))),
                  DataColumn(label: Text('Tgl. Setor', style: TextStyle(fontSize: fontSize - 4))),
                  DataColumn(label: Text('Status', style: TextStyle(fontSize: fontSize - 4))),
                  DataColumn(label: Text('Aksi', style: TextStyle(fontSize: fontSize - 4))),
                ],
                rows: setoranList.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> setoran = entry.value;
                  return DataRow(cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text('${setoran['surat']} sampai ${setoran['sampaiSurat']} Ayat: ${setoran['ayatAwal']} - ${setoran['ayatAkhir']}')),
                    DataCell(Text(setoran['tanggalSetoran'])),
                    DataCell(Text('Diterima')),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailPage(setoranId: index + 1)),
                          );
                        },
                        child: Text('Detail'),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final int setoranId;

  DetailPage({required this.setoranId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Setoran"),
        backgroundColor: Color(0xff2DA2A1),
      ),
      body: Center(
        child: Text("Detail untuk setoran ID: $setoranId"),
      ),
    );
  }
}

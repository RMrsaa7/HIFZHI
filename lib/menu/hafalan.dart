import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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
  TextEditingController _namaPesertaController = TextEditingController();
  TextEditingController _nomorRegistrasiController =
      TextEditingController(text: '12345');
  TextEditingController _ayatAwalController = TextEditingController();
  TextEditingController _ayatAkhirController = TextEditingController();
  String? _selectedSurat;
  String? _selectedSampaiSurat;
  String? _selectedJuz;
  String? _selectedJenisSetoran;
  List<String> _suratList = [];
  String? _fileName;
  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    _fetchSurat();
  }

  Future<void> _fetchSurat() async {
    final response = await http
        .get(Uri.parse('https://quran-api.santrikoding.com/api/surah'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        _suratList = data
            .map((surat) =>
                "${surat['nomor']}. ${surat['nama_latin']}" as String)
            .toList();
      });
    } else {
      throw Exception('Failed to load surat');
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
        _fileName = result.files.single.name;
      });
    }
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          height: 60,
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(icon, color: Color(0xff2DA2A1)),
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          height: 60,
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(hint,
                  style: TextStyle(color: Colors.black38, fontSize: 16)),
            ),
            value: value,
            icon: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_drop_down, color: Color(0xff2DA2A1)),
            ),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black87),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'LAMPIRKAN AUDIO HAFALAN',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedFile != null
                      ? _selectedFile!.name
                      : 'Tidak ada file yang dipilih',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Pilih File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff2DA2A1),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitHafalan() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih file audio terlebih dahulu')),
      );
      return;
    }

    // Misalkan URL endpoint API untuk mengunggah hafalan
    final url = Uri.parse('https://api.example.com/upload');

    // Buat request multipart
    var request = http.MultipartRequest('POST', url)
      ..fields['nama_peserta'] = _namaPesertaController.text
      ..fields['nomor_registrasi'] = _nomorRegistrasiController.text
      ..fields['surat'] = _selectedSurat ?? ''
      ..fields['sampai_surat'] = _selectedSampaiSurat ?? ''
      ..fields['ayat_awal'] = _ayatAwalController.text
      ..fields['ayat_akhir'] = _ayatAkhirController.text
      ..fields['juz'] = _selectedJuz ?? ''
      ..fields['jenis_setoran'] = _selectedJenisSetoran ?? '';

    if (_selectedFile != null) {
      request.files.add(
        http.MultipartFile(
          'file',
          File(_selectedFile!.path!).readAsBytes().asStream(),
          File(_selectedFile!.path!).lengthSync(),
          filename: _selectedFile!.name,
        ),
      );
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hafalan telah disetorkan!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah hafalan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitHafalan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff2DA2A1),
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Setorkan Hafalan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Setoran Hafalan',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Color(0xff2DA2A1),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                labelText: 'Nama Peserta',
                controller: _namaPesertaController,
                icon: Icons.person,
              ),
              _buildTextField(
                labelText: 'Nomor Registrasi',
                controller: _nomorRegistrasiController,
                icon: Icons.assignment,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      hint: 'Surat',
                      items: _suratList,
                      value: _selectedSurat,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSurat = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      hint: 'Sampai Surat',
                      items: _suratList,
                      value: _selectedSampaiSurat,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSampaiSurat = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      labelText: 'Ayat Awal',
                      controller: _ayatAwalController,
                      icon: Icons.book,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      labelText: 'Ayat Akhir',
                      controller: _ayatAkhirController,
                      icon: Icons.book,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Juz",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              _buildDropdown(
                hint: 'Juz',
                items: List.generate(30, (index) => (index + 1).toString()),
                value: _selectedJuz,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJuz = newValue;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 2, right: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Jenis Setoran",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              _buildDropdown(
                hint: 'Jenis Setoran',
                items: ['Talaqqi (Bacaan)', 'Ziyadah (Hafalan)'],
                value: _selectedJenisSetoran,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJenisSetoran = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xffFFEB3B),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERHATIAN..!!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Pastikan file yang akan Anda upload merupakan rekaman setoran yang benar dan dapat diputar dengan jelas.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '2. Buat nama file sesuai yang di setorkan untuk memudahkan proses upload.\nContoh: Al Baqarah 1-5, Al Baqarah 6-10',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '3. Pastikan file rekaman yang diupload tertulis extensionnya dengan jelas.\nContoh Benar: Al Baqarah 1-5.mp3\nContoh Salah: Al Baqarah 1-5',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              _buildFilePicker(),
              SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

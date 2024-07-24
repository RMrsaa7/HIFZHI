import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // untuk kIsWeb

class HafalanPage extends StatefulWidget {
  @override
  _HafalanPageState createState() => _HafalanPageState();
}

class _HafalanPageState extends State<HafalanPage> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _namaPesertaController = TextEditingController();
  TextEditingController _nomorRegistrasiController = TextEditingController(text: '17221020');
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
          _namaPesertaController.text = userDoc['username'] ?? 'User';
        });
      }
    }
  }

  Future<void> _fetchSurat() async {
    final response = await http.get(Uri.parse('https://quran-api.santrikoding.com/api/surah'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        _suratList = data.map((surat) => "${surat['nomor']}. ${surat['nama_latin']}" as String).toList();
      });
    } else {
      throw Exception('Failed to load surat');
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
        _fileName = result.files.single.name;
      });
    }
  }

  Future<String> _uploadFile(PlatformFile file) async {
    String fileName = _fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child('audio_hafalan/$fileName');

    if (kIsWeb) {
      // Menggunakan bytes untuk platform web
      UploadTask uploadTask = storageReference.putData(file.bytes!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } else {
      // Menggunakan path untuk platform non-web
      File fileToUpload = File(file.path!);
      UploadTask uploadTask = storageReference.putFile(fileToUpload);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    }
  }

  Future<void> _submitHafalan() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih file audio terlebih dahulu')),
      );
      return;
    }

    try {
      String audioUrl = await _uploadFile(_selectedFile!);

      // Simpan data ke Firestore
      await FirebaseFirestore.instance.collection('hafalan').add({
        'nama_peserta': _namaPesertaController.text,
        'nomor_registrasi': _nomorRegistrasiController.text,
        'surat': _selectedSurat ?? '',
        'sampai_surat': _selectedSampaiSurat ?? '',
        'ayat_awal': _ayatAwalController.text,
        'ayat_akhir': _ayatAkhirController.text,
        'juz': _selectedJuz ?? '',
        'jenis_setoran': _selectedJenisSetoran ?? '',
        'audio_url': audioUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hafalan telah disetorkan!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
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
              child: Text(hint, style: TextStyle(color: Colors.black38, fontSize: 16)),
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
                  _selectedFile != null ? _selectedFile!.name : 'Tidak ada file yang dipilih',
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
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text('Form Setoran Hafalan'),
        backgroundColor: Color(0xff2DA2A1),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTextField(
              labelText: 'Nama Peserta',
              controller: _namaPesertaController,
              icon: Icons.person,
            ),
            _buildTextField(
              labelText: 'Nomor Registrasi',
              controller: _nomorRegistrasiController,
              icon: Icons.assignment_ind,
            ),
            _buildDropdown(
              hint: 'Pilih Surat',
              items: _suratList,
              value: _selectedSurat,
              onChanged: (value) {
                setState(() {
                  _selectedSurat = value;
                });
              },
            ),
            _buildDropdown(
              hint: 'Sampai Surat',
              items: _suratList,
              value: _selectedSampaiSurat,
              onChanged: (value) {
                setState(() {
                  _selectedSampaiSurat = value;
                });
              },
            ),
            _buildTextField(
              labelText: 'Ayat Awal',
              controller: _ayatAwalController,
              icon: Icons.format_list_numbered,
            ),
            _buildTextField(
              labelText: 'Ayat Akhir',
              controller: _ayatAkhirController,
              icon: Icons.format_list_numbered,
            ),
            _buildDropdown(
              hint: 'Pilih Juz',
              items: List<String>.generate(30, (index) => 'Juz ${index + 1}'),
              value: _selectedJuz,
              onChanged: (value) {
                setState(() {
                  _selectedJuz = value;
                });
              },
            ),
            _buildDropdown(
              hint: 'Jenis Setoran',
              items: ['Muraja\'ah', 'Setoran Baru'],
              value: _selectedJenisSetoran,
              onChanged: (value) {
                setState(() {
                  _selectedJenisSetoran = value;
                });
              },
            ),
            _buildFilePicker(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}

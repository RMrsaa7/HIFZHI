import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  TextEditingController _dateController = TextEditingController();
  String? _selectedSurat;
  String? _selectedSampaiSurat;
  String? _selectedJuz;
  String? _selectedJenisSetoran;
  List<String> _suratList = [];
  String? _fileName;
  PlatformFile? _selectedFile;
  DateTime? selectedDate;
  double _uploadProgressStorage = 0.0;
  bool _isUploading = false;
  String? _audioUrl;

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
      throw Exception('Gagal memuat surat');
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

  Future<void> _uploadFileToStorage() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih file audio terlebih dahulu', style: GoogleFonts.poppins())),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = _fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('audio_hafalan/$fileName');

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = storageReference.putData(_selectedFile!.bytes!);
      } else {
        File fileToUpload = File(_selectedFile!.path!);
        uploadTask = storageReference.putFile(fileToUpload);
      }

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgressStorage = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        });
      });

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _audioUrl = downloadUrl;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File berhasil diunggah! URL: $downloadUrl', style: GoogleFonts.poppins())),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e', style: GoogleFonts.poppins())),
      );
    }
  }

  Future<void> _submitHafalan() async {
    if (_audioUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap unggah file audio terlebih dahulu', style: GoogleFonts.poppins())),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih tanggal setoran terlebih dahulu', style: GoogleFonts.poppins())),
      );
      return;
    }

    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Setorkan Hafalan'),
        content: Text('Apakah Anda yakin ingin menyetorkan hafalan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ya'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('hafalan').add({
        'nama_peserta': _namaPesertaController.text,
        'nomor_registrasi': _nomorRegistrasiController.text,
        'surat': _selectedSurat ?? '',
        'sampai_surat': _selectedSampaiSurat ?? '',
        'ayat_awal': _ayatAwalController.text,
        'ayat_akhir': _ayatAkhirController.text,
        'juz': _selectedJuz ?? '',
        'jenis_setoran': _selectedJenisSetoran ?? '',
        'audio_url': _audioUrl,
        'tanggal_setoran': selectedDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hafalan telah disetorkan!', style: GoogleFonts.poppins())),
      );

      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e', style: GoogleFonts.poppins())),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _namaPesertaController.clear();
      _nomorRegistrasiController.clear();
      _ayatAwalController.clear();
      _ayatAkhirController.clear();
      _dateController.clear();
      _selectedSurat = null;
      _selectedSampaiSurat = null;
      _selectedJuz = null;
      _selectedJenisSetoran = null;
      _fileName = null;
      _selectedFile = null;
      selectedDate = null;
      _audioUrl = null;
      _uploadProgressStorage = 0.0;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: GoogleFonts.poppins(color: Colors.black87),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Color(0xff2DA2A1)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            labelText: labelText,
            labelStyle: GoogleFonts.poppins(color: Color(0xff2DA2A1)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
    double iconPadding = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          icon: icon != null
              ? Padding(
                  padding: EdgeInsets.only(right: iconPadding),
                  child: Icon(icon, color: Color(0xff2DA2A1)),
                )
              : null,
          style: GoogleFonts.poppins(color: Colors.black87),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Color(0xff2DA2A1)),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2DA2A1),
      appBar: AppBar(
        title: Text('Setor Hafalan', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Color(0xff2DA2A1),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              labelText: 'Nama Peserta',
              controller: _namaPesertaController,
              icon: Icons.person,
            ),
            _buildTextField(
              labelText: 'Nomor Registrasi',
              controller: _nomorRegistrasiController,
              icon: Icons.format_list_numbered,
            ),
            InkWell(
              onTap: () => _selectDate(context),
              child: IgnorePointer(
                child: _buildTextField(
                  labelText: 'Tanggal Setoran',
                  controller: _dateController,
                  icon: Icons.date_range,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    hintText: 'Pilih Surat',
                    selectedValue: _selectedSurat,
                    items: _suratList,
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
                    hintText: 'Sampai Surat',
                    selectedValue: _selectedSampaiSurat,
                    items: _suratList,
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
                    icon: Icons.format_list_numbered,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    labelText: 'Ayat Akhir',
                    controller: _ayatAkhirController,
                    icon: Icons.format_list_numbered,
                  ),
                ),
              ],
            ),
            _buildDropdown(
              hintText: 'Pilih Juz',
              selectedValue: _selectedJuz,
              items: List.generate(30, (index) => 'Juz ${index + 1}'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedJuz = newValue;
                });
              },
            ),
            _buildDropdown(
              hintText: 'Jenis Setoran',
              selectedValue: _selectedJenisSetoran,
              items: ['Murajaah', 'Ziyadah'],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedJenisSetoran = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.attach_file),
              label: Text(
                _fileName == null ? 'Pilih File Audio' : _fileName!,
                style: GoogleFonts.poppins(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xff2DA2A1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 18,  horizontal: 165),
              ),
            ),
            SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator(
                    value: _uploadProgressStorage / 100,
                    color: Colors.white,
                  )
                : ElevatedButton.icon(
                    onPressed: _uploadFileToStorage,
                    icon: Icon(Icons.cloud_upload),
                    label: Text('Upload File', style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xff2DA2A1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18,  horizontal: 175),
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitHafalan,
              label: Text('Setorkan Hafalan', style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xff2DA2A1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 170),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

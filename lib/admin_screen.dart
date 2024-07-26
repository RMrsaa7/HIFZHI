import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  DateTime? _selectedDate;

  Future<List<DocumentSnapshot>> _fetchHafalan() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('hafalan')
        .orderBy('tanggal_setoran', descending: true) // Mengurutkan berdasarkan tanggal_setoran terbaru
        .get();
    return querySnapshot.docs;
  }

  void _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isPlaying = true;
    });
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _stopAudio() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _submitPenilaian(DocumentSnapshot hafalan, Map<String, dynamic> penilaian) async {
    await _firestore.collection('hafalan').doc(hafalan.id).update(penilaian);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Penilaian telah disimpan')));
    setState(() {});
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda ingin logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog
                await FirebaseAuth.instance.signOut(); // Logout dari Firebase
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Navigasi ke halaman login
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Admin Hafalan'),
        backgroundColor: Color(0xff2DA2A1),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchHafalan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data hafalan'));
          }

          List<DocumentSnapshot> hafalanList = snapshot.data!;

          return ListView.builder(
            itemCount: hafalanList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot hafalan = hafalanList[index];
              Map<String, dynamic> data = hafalan.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data['nama_peserta'] ?? 'Nama Peserta'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Surat: ${data['surat'] ?? 'Tidak tersedia'}'),
                      Text('Sampai Surat: ${data['sampai_surat'] ?? 'Tidak tersedia'}'),
                      Text('Ayat: ${data['ayat_awal'] ?? 'Tidak tersedia'} - ${data['ayat_akhir'] ?? 'Tidak tersedia'}'),
                      Text('Juz: ${data['juz'] ?? 'Tidak tersedia'}'),
                      Text('Jenis Setoran: ${data['jenis_setoran'] ?? 'Tidak tersedia'}'),
                      Text('Penilaian: ${data['status'] == 'sudah dinilai' ? 'Sudah dinilai' : 'Belum dinilai'}'),
                      Text('Feedback: ${data['feedback'] ?? 'Belum ada feedback'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (_isPlaying) {
                            _pauseAudio();
                          } else {
                            _playAudio(data['audio_url'] ?? '');
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: _stopAudio,
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController _feedbackController = TextEditingController();
                        TextEditingController _makhrojulHurufController = TextEditingController(text: data['makhrojulHuruf']?.toString() ?? '');
                        TextEditingController _hukumTajwidController = TextEditingController(text: data['hukumTajwid']?.toString() ?? '');
                        TextEditingController _hukumMadController = TextEditingController(text: data['hukumMad']?.toString() ?? '');
                        TextEditingController _hukumWaqafIbtidaController = TextEditingController(text: data['hukumWaqafIbtida']?.toString() ?? '');
                        TextEditingController _kelancaranHafalanController = TextEditingController(text: data['kelancaranHafalan']?.toString() ?? '');
                        TextEditingController _kualitasHafalanController = TextEditingController(text: data['kualitasHafalan']?.toString() ?? '');
                        TextEditingController _musyrifDiTempatTinggalController = TextEditingController(text: data['musyrifDiTempatTinggal'] ?? '');
                        TextEditingController _namaMusyrifController = TextEditingController(text: data['namaMusyrif'] ?? '');

                        return AlertDialog(
                          title: Text('Penilaian Hafalan'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                 _buildPenilaianRow('Nama Musyrif', _namaMusyrifController),
                                _buildPenilaianRow('Makhrojul Huruf', _makhrojulHurufController),
                                _buildPenilaianRow('Hukum Tajwid', _hukumTajwidController),
                                _buildPenilaianRow('Hukum Mad', _hukumMadController),
                                _buildPenilaianRow('Hukum Waqaf Ibtida', _hukumWaqafIbtidaController),
                                _buildPenilaianRow('Kelancaran Hafalan', _kelancaranHafalanController),
                                _buildPenilaianRow('Kualitas Hafalan', _kualitasHafalanController),
                                _buildPenilaianRow('Musyrif di Tempat Tinggal', _musyrifDiTempatTinggalController),
                                TextField(
                                  controller: _feedbackController,
                                  decoration: InputDecoration(labelText: 'Feedback'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedDate == null
                                            ? 'Tanggal Dinilai: Belum dipilih'
                                            : 'Tanggal Dinilai: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              _selectedDate = pickedDate;
                                            });
                                          }
                                        },
                                        child: Text('Pilih Tanggal'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                _submitPenilaian(hafalan, {
                                  'makhrojulHuruf': double.tryParse(_makhrojulHurufController.text) ?? 0,
                                  'hukumTajwid': double.tryParse(_hukumTajwidController.text) ?? 0,
                                  'hukumMad': double.tryParse(_hukumMadController.text) ?? 0,
                                  'hukumWaqafIbtida': double.tryParse(_hukumWaqafIbtidaController.text) ?? 0,
                                  'kelancaranHafalan': double.tryParse(_kelancaranHafalanController.text) ?? 0,
                                  'kualitasHafalan': double.tryParse(_kualitasHafalanController.text) ?? 0,
                                  'musyrifDiTempatTinggal': _musyrifDiTempatTinggalController.text,
                                  'namaMusyrif': _namaMusyrifController.text,
                                  'feedback': _feedbackController.text,
                                  'tanggal_dinilai': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
                                  'status': 'sudah dinilai',
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Simpan'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPenilaianRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<List<Map<String, dynamic>>> _fetchHafalan() async {
    QuerySnapshot querySnapshot = await _firestore.collection('hafalan').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  void _playAudio(String url) {
    _audioPlayer.play(UrlSource(url));
  }

  void _stopAudio() {
    _audioPlayer.stop();
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
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchHafalan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data hafalan'));
          }

          List<Map<String, dynamic>> hafalanList = snapshot.data!;

          return ListView.builder(
            itemCount: hafalanList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> hafalan = hafalanList[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(hafalan['nama_peserta']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Surat: ${hafalan['surat']}'),
                      Text('Sampai Surat: ${hafalan['sampai_surat']}'),
                      Text('Ayat: ${hafalan['ayat_awal']} - ${hafalan['ayat_akhir']}'),
                      Text('Juz: ${hafalan['juz']}'),
                      Text('Jenis Setoran: ${hafalan['jenis_setoran']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      _playAudio(hafalan['audio_url']);
                    },
                  ),
                  onTap: () {
                    _playAudio(hafalan['audio_url']);
                  },
                  onLongPress: () {
                    _stopAudio();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

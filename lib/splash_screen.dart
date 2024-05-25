import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late BuildContext _ctx; // Tambahkan variabel untuk menyimpan context

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Simpan context saat initState dipanggil
    _ctx = context;

    Future.delayed(Duration(seconds: 3), () {
      // Gunakan variabel context yang telah disimpan
      Navigator.of(_ctx).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white, Color(0xCC38A6A5), Color(0xCC38A6A5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/logo.png'), // Lokasi gambar
              width: 400, // Lebar gambar
              height: 400, // Tinggi gambar
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}

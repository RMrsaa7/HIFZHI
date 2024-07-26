import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCSobIBFP6UbESUVNdQFVS4YACQOfIG2aU",
        authDomain: "hifzhi-app.firebaseapp.com",
        projectId: "hifzhi-app",
        storageBucket: "hifzhi-app.appspot.com",
        messagingSenderId: "621485503038",
        appId: "1:621485503038:web:4ce95b2d740bbd3b1b176f",
        measurementId: "G-MCJT1GW3RG",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIFZHI APP',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

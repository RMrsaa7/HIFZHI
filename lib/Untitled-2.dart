import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hifzhi/services/auth_services.dart';
import 'package:hifzhi/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final AuthService _authService =
      AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);

  bool _obscureText = true;
  bool _showPassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
      _obscureText = !_showPassword;
    });
  }

  Future<void> _registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();

    String result = await _authService.signUp(email, password, username);
    if (result == "Signed Up") {
      print('User registered: $username');
      await _showSuccessDialog(); // Tampilkan dialog sukses setelah menyimpan data
    } else {
      print('Registration failed: $result');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Pendaftaran gagal: $result')));
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Dialog tidak bisa ditutup dengan mengetuk di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrasi Berhasil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Registrasi berhasil, Anda telah terdaftar.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}

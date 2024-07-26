import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';
import 'beranda.dart';
import 'package:hifzhi/admin_screen.dart'; 
import 'package:hifzhi/services/auth_services.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final AuthService _authService = AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _showPassword = false;
  String _errorText = '';
  bool _loginError = false; 

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
      _obscureText = !_showPassword;
    });
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _errorText = 'Email dan password harus diisi';
        });
        return;
      }

      User? user = await _authService.signIn(email, password);

      if (user != null) {
        if (email == 'rdmarissalestari@gmail.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BerandaScreen()),
          );
        }
      } else {
        setState(() {
          _loginError = true; // Tampilkan pesan kesalahan
        });
        _hideErrorMessage();
      }
    } catch (e) {
      print('Error saat sign-in: $e');
      String errorMessage = 'Terjadi kesalahan saat login';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Terjadi kesalahan saat login';
      }
      setState(() {
        _loginError = true; // Tampilkan pesan kesalahan
      });
      _hideErrorMessage();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $errorMessage')),
      );
    }
  }

  void _hideErrorMessage() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _loginError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFFFF),
                      Color(0xCC38A6A5),
                      Color(0xCC38A6A5),
                    ])),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo.png',
                        height: 90,
                      ),
                      SizedBox(height: 50),
                      if (_loginError) // Tampilkan pesan kesalahan jika ada
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Email atau Password yang dimasukkan salah',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                        offset: Offset(0, 2))
                                  ]),
                              height: 60,
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(Icons.email,
                                        color: Color(0xff38A6A5)),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        color: Colors.black38, fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                        offset: Offset(0, 2))
                                  ]),
                              height: 60,
                              child: Stack(
                                children: [
                                  TextField(
                                    controller: passwordController,
                                    obscureText: _obscureText,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Color(0xff38A6A5)),
                                        hintText: 'Password',
                                        hintStyle:
                                            TextStyle(color: Colors.black38)),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 10,
                                    child: Visibility(
                                      visible: _errorText.isNotEmpty,
                                      child: Text(
                                        _errorText,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 8,
                                    child: IconButton(
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xff38A6A5),
                                      ),
                                      onPressed: _togglePasswordVisibility,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: _signInWithEmailAndPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                                0xff38A6A5), // Warna latar belakang tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Daftar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

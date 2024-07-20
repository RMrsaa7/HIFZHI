import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda.dart'; // Sesuaikan dengan path yang benar
import 'register.dart'; // Path untuk RegisterScreen

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _showPassword = false;
  String _errorText = '';

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

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BerandaScreen(user: user)),
        );
      }
    } catch (e) {
      print('Error saat sign-in: $e');
      String errorMessage = 'Terjadi kesalahan saat login';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Terjadi kesalahan saat login';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $errorMessage')),
      );
    }
  }

  Widget buildEmail() {
    return Column(
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
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Color(0xff38A6A5)),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 16)),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
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
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
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
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.lock, color: Color(0xff38A6A5)),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.black38)),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                child: Visibility(
                  visible: _errorText.isNotEmpty,
                  child: Text(
                    _errorText,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildShowPasswordCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _showPassword,
              onChanged: (value) {
                _togglePasswordVisibility();
              },
              activeColor: Color(0xff38A6A5),
              checkColor: Colors.white,
              side: MaterialStateBorderSide.resolveWith(
                (Set<MaterialState> states) {
                  if (!states.contains(MaterialState.selected)) {
                    return BorderSide(color: Colors.white);
                  }
                  return BorderSide(color: Colors.white);
                },
              ),
            ),
            Text(
              'Tampilkan Password',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        buildForgotPassBtn(),
      ],
    );
  }

  Widget buildForgotPassBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Lupa password Pressed'),
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(right: 0),
        ),
        child: Text(
          'Lupa Password?',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 5,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 53, 170, 168),
                Color.fromARGB(255, 24, 145, 145)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: _signInWithEmailAndPassword,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Belum punya akun? ',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextSpan(
                text: 'Daftar',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
      ),
    );
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: buildEmail(),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: buildPassword(),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: buildShowPasswordCheckbox(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: buildLoginBtn(),
                      ),
                      buildSignupBtn(),
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

void main() {
  runApp(MaterialApp(
    title: 'Login Screen',
    home: LoginScreen(),
  ));
}

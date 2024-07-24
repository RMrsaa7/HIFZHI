import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hifzhi/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final AuthService _authService = AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);

  bool _obscureText = true;
  bool _showPassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
      _obscureText = !_showPassword;
    });
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Akun berhasil dibuat.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
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
            obscureText: isPassword ? _obscureText : false,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(icon, color: Color(0xff38A6A5)),
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String email = emailController.text.trim();
          String password = passwordController.text.trim();
          String username = usernameController.text.trim();

          String result = await _authService.signUp(email, password, username);
          if (result == "Signed Up") {
            print('User registered: $username');
            await _showSuccessDialog(); // Show success dialog after saving data
          } else {
            print('Registration failed: $result');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pendaftaran gagal: $result'))
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'DAFTAR',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 37, 169, 169),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Akun'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 90,
              ),
              SizedBox(height: 50),
              _buildTextField(
                labelText: 'Nama Lengkap',
                icon: Icons.person,
                controller: usernameController,
              ),
              _buildTextField(
                labelText: 'Email',
                icon: Icons.email,
                controller: emailController,
              ),
              _buildTextField(
                labelText: 'Kata Sandi *Buat kata sandi kuat 8 karakter kombinasi',
                icon: Icons.lock,
                isPassword: true,
                controller: passwordController,
              ),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Register Screen',
    home: RegisterScreen(),
  ));
}

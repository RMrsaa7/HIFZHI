import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  Future<void> _changePassword(String oldPassword, String newPassword) async {
    User? user = _auth.currentUser;
    String email = user?.email ?? '';

    try {
      // Reauthenticate the user
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await user?.reauthenticateWithCredential(credential);

      // Update the password
      await user?.updatePassword(newPassword);
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(content: Text('Password berhasil diubah')),
          )
          .closed
          .then((reason) {
        Navigator.pop(context);
      });
    } catch (error) {
      print("Password can't be changed" + error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah password: ${error.toString()}')),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Ubah Password'),
          content: Text('Apakah Anda yakin ingin mengubah password?'),
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
                if (_formKey.currentState!.validate()) {
                  await _changePassword(
                      _oldPasswordController.text, _newPasswordController.text);
                }
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
        title: Text('Ubah Password'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPasswordField(
                  controller: _oldPasswordController,
                  label: 'Password Lama',
                  showPassword: _showOldPassword,
                  toggleShowPassword: () {
                    setState(() {
                      _showOldPassword = !_showOldPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan password lama Anda';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'Password Baru',
                  showPassword: _showNewPassword,
                  toggleShowPassword: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan password baru Anda';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password Baru',
                  showPassword: _showConfirmPassword,
                  toggleShowPassword: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon konfirmasi password baru Anda';
                    } else if (value != _newPasswordController.text) {
                      return 'Password konfirmasi tidak cocok';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  child: Text('Ubah Password'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff38A6A5),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Pastikan ini diatur
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool showPassword,
    required Function toggleShowPassword,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            toggleShowPassword();
          },
        ),
      ),
      obscureText: !showPassword,
      validator: validator,
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

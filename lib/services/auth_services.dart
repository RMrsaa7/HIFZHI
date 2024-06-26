import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(String email, String password, String role, String username) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
        User? user = _auth.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            'uid': user.uid,
            'email': email,
            'username': username,
            'role': role
          });
        }
      });
      return "Signed Up";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}

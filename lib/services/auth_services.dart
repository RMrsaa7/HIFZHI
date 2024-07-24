import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService(this._firebaseAuth, this._firestore);

  Future<String> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Menentukan role berdasarkan email
      String role = (email == 'rdmarissalestari@gmail.com') ? 'admin' : 'user';

      // Menambahkan data pengguna ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role, // Mengatur role sebagai 'admin' atau 'user'
        'username': username,
      });

      return "Signed Up";
    } catch (e) {
      return e.toString();
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

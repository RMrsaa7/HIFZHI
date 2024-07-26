import 'dart:typed_data'; // Tambahkan baris ini
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<UploadTask?> uploadFile(String destination, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      // Handle the exception
      print("Firebase Storage Error: $e");
      return null;
    }
  }

  Future<UploadTask?> uploadBytes(String destination, Uint8List data) async {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException catch (e) {
      // Handle the exception
      print("Firebase Storage Error: $e");
      return null;
    }
  }
}

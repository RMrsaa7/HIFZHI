import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      allowMultiple: false,
    );

    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}

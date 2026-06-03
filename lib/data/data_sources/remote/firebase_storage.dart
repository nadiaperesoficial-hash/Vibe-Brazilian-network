import 'dart:io';
import 'dart:typed_data';
import 'package:vibe/core/utility/cloudinary_service.dart';

class FirebaseStoragePost {
  static final _cloudinary = CloudinaryService();

  static Future<String> uploadFile(File file, String destination) async {
    final url = await _cloudinary.uploadImage(file);
    return url ?? '';
  }

  static Future<String> uploadData(Uint8List data, String destination) async {
    final url = await _cloudinary.uploadBytes(data, destination);
    return url ?? '';
  }

  static Future<void> deleteImageFromStorage(String url) async {
    // implementar se necessário
  }
}

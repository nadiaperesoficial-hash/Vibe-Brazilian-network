import 'dart:io';
import 'package:vibe/core/utility/cloudinary_service.dart';

class StorageRepository {
  final _cloudinary = CloudinaryService();

  Future<String> uploadFile(File postFile, String destination) async {
    final url = await _cloudinary.uploadImage(postFile);
    return url ?? '';
  }

  Future<String> uploadData(dynamic data, String destination) async {
    return '';
  }

  Future<void> deleteFile(String previousFileUrl) async {
    // Cloudinary deletion via API se necessário
  }
}

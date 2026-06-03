import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vibe/core/utility/cloudinary_keys.dart';

class FirebaseStoragePost {
  static Future<String> uploadFile({
    required File postFile,
    required String folderName,
  }) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${CloudinaryKeys.cloudName}/auto/upload',
      );
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = CloudinaryKeys.uploadPreset
        ..fields['folder'] = 'vibe/$folderName'
        ..files.add(await http.MultipartFile.fromPath('file', postFile.path));
      final response = await request.send();
      final body = await response.stream.bytesToString();
      final json = jsonDecode(body);
      return json['secure_url'] as String? ?? '';
    } catch (e) {
      return '';
    }
  }

  static Future<String> uploadData({
    required Uint8List data,
    required String folderName,
  }) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${CloudinaryKeys.cloudName}/auto/upload',
      );
      final base64Data = base64Encode(data);
      final response = await http.post(uri, body: {
        'file': 'data:application/octet-stream;base64,$base64Data',
        'upload_preset': CloudinaryKeys.uploadPreset,
        'folder': 'vibe/$folderName',
      });
      final json = jsonDecode(response.body);
      return json['secure_url'] as String? ?? '';
    } catch (e) {
      return '';
    }
  }

  static Future<void> deleteImageFromStorage(String url) async {}
}

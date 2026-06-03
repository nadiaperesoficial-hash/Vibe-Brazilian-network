import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cloudinary_keys.dart';

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  Future<String?> uploadImage(File file) async {
    return _upload(file, 'image', 'vibe/posts');
  }

  Future<String?> uploadVideo(File file) async {
    return _upload(file, 'video', 'vibe/posts');
  }

  Future<String?> uploadProfileImage(File file) async {
    return _upload(file, 'image', 'vibe/profiles');
  }

  Future<String?> uploadBytes(List<int> bytes, String folder) async {
    return _uploadBytes(bytes, 'image', folder);
  }

  Future<String?> _upload(File file, String resourceType, String folder) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${CloudinaryKeys.cloudName}/$resourceType/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = CloudinaryKeys.uploadPreset
      ..fields['folder'] = folder
      ..files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await request.send();
    final body = await response.stream.bytesToString();
    final json = jsonDecode(body);
    return json['secure_url'] as String?;
  }

  Future<String?> _uploadBytes(List<int> bytes, String resourceType, String folder) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${CloudinaryKeys.cloudName}/$resourceType/upload',
    );
    final base64Data = base64Encode(bytes);
    final response = await http.post(uri, body: {
      'file': 'data:image/jpeg;base64,$base64Data',
      'upload_preset': CloudinaryKeys.uploadPreset,
      'folder': folder,
    });
    final json = jsonDecode(response.body);
    return json['secure_url'] as String?;
  }
}

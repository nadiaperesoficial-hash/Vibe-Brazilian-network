import 'dart:io';
import 'package:cloudinary_flutter/cloudinary_flutter.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'cloudinary_keys.dart';

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  final cloudinary = Cloudinary.withStringUrl(
    'cloudinary://${CloudinaryKeys.apiKey}@${CloudinaryKeys.cloudName}',
  );

  Future<String?> uploadImage(File file) async {
    try {
      final response = await cloudinary.uploader().upload(
        file.path,
        uploadPreset: CloudinaryKeys.uploadPreset,
        folder: 'vibe/posts',
        resourceType: CloudinaryResourceType.image,
      );
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadVideo(File file) async {
    try {
      final response = await cloudinary.uploader().upload(
        file.path,
        uploadPreset: CloudinaryKeys.uploadPreset,
        folder: 'vibe/posts',
        resourceType: CloudinaryResourceType.video,
      );
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadProfileImage(File file) async {
    try {
      final response = await cloudinary.uploader().upload(
        file.path,
        uploadPreset: CloudinaryKeys.uploadPreset,
        folder: 'vibe/profiles',
        resourceType: CloudinaryResourceType.image,
      );
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }
}

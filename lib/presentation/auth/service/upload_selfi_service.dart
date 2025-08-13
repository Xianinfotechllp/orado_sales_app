// services/selfie_upload_service.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:demo/presentation/auth/model/upload_selfi_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelfieUploadService {
  final String baseUrl = 'https://orado-backend.onrender.com';

  Future<UploadSelfieResponse> uploadSelfie(File selfieFile) async {
    final url = Uri.parse('$baseUrl/agent/upload-selfie');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      if (token == null) {
        throw Exception('Token not found in SharedPreferences');
      }

      final request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('selfie', selfieFile.path),
      );

      log('Sending selfie upload request to $url');
      log('Attached file path: ${selfieFile.path}');
      log('Authorization: Bearer $token');

      final response = await request.send();

      log('Upload status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        log('Upload response body: $body');

        final data = jsonDecode(body);
        return UploadSelfieResponse.fromJson(data);
      } else {
        final errorBody = await response.stream.bytesToString();
        log('Failed response body: $errorBody');
        throw Exception('Failed to upload selfie');
      }
    } catch (e, stackTrace) {
      log('Error during selfie upload', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

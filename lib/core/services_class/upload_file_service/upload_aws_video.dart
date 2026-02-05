// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:http_parser/http_parser.dart';

class UploadAwsVideo {
  static Future<String> uploadVideo(File file) async {
    final uri = Uri.parse(Urls.awsFileUpload); 

    var request = http.MultipartRequest('POST', uri);

    // Detect video MIME type
    String extension = file.path.split('.').last.toLowerCase();

    MediaType contentType;

    switch (extension) {
      case 'mp4':
        contentType = MediaType('video', 'mp4');
        break;
      case 'mov':
        contentType = MediaType('video', 'quicktime');
        break;
      case 'avi':
        contentType = MediaType('video', 'x-msvideo');
        break;
      case 'mkv':
        contentType = MediaType('video', 'x-matroska');
        break;
      default:
        contentType = MediaType('video', 'mp4');
    }

    var multipartFile = await http.MultipartFile.fromPath(
      'files', // field name same as image upload
      file.path,
      filename: file.uri.pathSegments.last,
      contentType: contentType,
    );

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        print('Video upload successful!');
      }

      var responseBody = await response.stream.bytesToString();
      String url = jsonDecode(responseBody)[0];

      if (kDebugMode) {
        print('Response: $responseBody');
      }

      return url;
    } else {
      var errorBody = await response.stream.bytesToString();

      if (kDebugMode) {
        print('Video upload failed: ${response.statusCode}');
        print('Error: $errorBody');
      }

      return '';
    }
  }
}

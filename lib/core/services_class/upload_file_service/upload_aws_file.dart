// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:http_parser/http_parser.dart';

class UploadAwsFile {
  static Future<String> uploadFile(File file) async {
    final uri = Uri.parse(Urls.awsFileUpload);

    // Create a multipart request
    var request = http.MultipartRequest('POST', uri);

    // Add the file
    var multipartFile = await http.MultipartFile.fromPath(
      'files', // field name expected by backend
      file.path,
      filename: file.uri.pathSegments.last,
      contentType: MediaType('image', 'jpeg'),
    );

    request.files.add(multipartFile);

    // Send request
    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        print('Upload successful!');
      }
      var responseBody = await response.stream.bytesToString();
      String url = jsonDecode(responseBody)[0];
      if (kDebugMode) {
        print(responseBody);
      }
      return url;
    } else {
      var errorBody = await response.stream.bytesToString();
      if (kDebugMode) {
        print('Upload failed with status: ${response.statusCode}');
        print('Upload failed with : $errorBody');
      }
      return '';
    }
  }
}

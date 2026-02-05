// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:http_parser/http_parser.dart';

class NgoVerificationService {
  /// Apply for NGO verification with multipart file upload
  /// 
  /// [ngoId] - The NGO ID
  /// [verificationType] - Either "GOVERMENT_AND_PASSPORT" or "BUSINESS_CERTIFIED_LICENSE"
  /// [file] - The file to upload
  /// 
  /// Returns a Map with 'success' (bool) and 'message' (String)
  static Future<Map<String, dynamic>> applyVerification({
    required String ngoId,
    required String verificationType,
    required File file,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final url = Urls.applyNgoVerification(ngoId);
      
      debugPrint('NGO Verification Apply - URL: $url');
      debugPrint('NGO Verification Apply - NGO ID: $ngoId');
      debugPrint('NGO Verification Apply - Verification Type: $verificationType');
      debugPrint('NGO Verification Apply - File Path: ${file.path}');
      debugPrint('NGO Verification Apply - File Size: ${await file.length()} bytes');

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['accept'] = '*/*';

      // Add verificationType field
      request.fields['verificationType'] = verificationType;

      // Add file
      var multipartFile = await http.MultipartFile.fromPath(
        'files',
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      debugPrint('Sending multipart request...');

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('NGO Verification Apply Response - Status Code: ${response.statusCode}');
      debugPrint('NGO Verification Apply Response - Body: ${response.body}');

      // Parse response
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseBody = response.body;
          Map<String, dynamic>? jsonData;
          
          if (responseBody.isNotEmpty) {
            try {
              jsonData = jsonDecode(responseBody) as Map<String, dynamic>?;
            } catch (e) {
              debugPrint('Error parsing JSON response: $e');
            }
          }
          
          final message = jsonData?['message'] as String? ?? 'Verification request submitted successfully';
          
          return {
            'success': true,
            'message': message,
            'data': jsonData,
          };
        } catch (e) {
          debugPrint('Error parsing success response: $e');
          return {
            'success': true,
            'message': 'Verification request submitted successfully',
          };
        }
      } else {
        // Error response
        try {
          final errorBody = response.body;
          debugPrint('Error Response Body: $errorBody');
          
          // Try to parse error message from JSON
          String errorMessage = 'Failed to submit verification request';
          String? errorField;
          
          if (errorBody.isNotEmpty) {
            try {
              final errorJson = jsonDecode(errorBody) as Map<String, dynamic>?;
              if (errorJson != null) {
                // Try to get error field first, then message
                errorField = errorJson['error'] as String?;
                errorMessage = errorField ?? 
                              (errorJson['message'] as String?) ?? 
                              errorMessage;
              }
            } catch (e) {
              debugPrint('Error parsing error JSON: $e');
              // Fallback to regex extraction if JSON parsing fails
              if (errorBody.contains('"error"')) {
                final errorMatch = RegExp(r'"error"\s*:\s*"([^"]+)"').firstMatch(errorBody);
                if (errorMatch != null) {
                  errorMessage = errorMatch.group(1) ?? errorMessage;
                }
              } else if (errorBody.contains('"message"')) {
                final messageMatch = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(errorBody);
                if (messageMatch != null) {
                  errorMessage = messageMatch.group(1) ?? errorMessage;
                }
              }
            }
          }
          
          return {
            'success': false,
            'message': errorMessage,
            'error': errorField ?? errorMessage,
          };
        } catch (e) {
          debugPrint('Error handling error response: $e');
          return {
            'success': false,
            'message': 'Failed to submit verification request. Status: ${response.statusCode}',
            'error': 'Server error: ${response.statusCode}',
          };
        }
      }
    } catch (e, stackTrace) {
      debugPrint('EXCEPTION in applyVerification: $e');
      debugPrint('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Something went wrong: ${e.toString()}',
        'error': e.toString(),
      };
    }
  }
}


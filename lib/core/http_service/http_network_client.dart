// lib/core/http_service/http_network_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:logger/logger.dart';

part 'http_network_response.dart';

class HttpNetworkClient {
  final String _defaultErrorMsg = 'Something went wrong';
  final Logger _logger = Logger();

  HttpNetworkClient();

  // GET request
  Future<HttpNetworkResponse> getRequest({required String url}) async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    Map<String, String> commonHeaders = {
      'Content-Type': 'application/json',
      'authorization': "Bearer $token",
    };
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: commonHeaders);
      final http.Response response = await http.get(uri, headers: commonHeaders);
      _logResponse(response: response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['message'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return HttpNetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  // POST request
  Future<HttpNetworkResponse> postRequest({
    required String url,
    required Map<String, dynamic>? body,
    Map<String, String>? extraHeaders,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    Map<String, String> commonHeaders = {
      'content-type': 'application/json',
      'authorization': "Bearer $token",
    };

    // Merge extra headers if provided
    final headers = <String, String>{};
    headers.addAll(commonHeaders);
    if (extraHeaders != null) headers.addAll(extraHeaders);

    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: headers, body: body);
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      _logResponse(response: response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['message'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return HttpNetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  // PUT request
  Future<HttpNetworkResponse> putRequest({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    Map<String, String> commonHeaders = {
      'content-type': 'application/json',
      'authorization': "Bearer $token",
    };
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: commonHeaders, body: body);
      final http.Response response = await http.put(
        uri,
        headers: commonHeaders,
        body: jsonEncode(body),
      );
      _logResponse(response: response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['message'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return HttpNetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  // PATCH request
  Future<HttpNetworkResponse> patchRequest({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    Map<String, String> commonHeaders = {
      'content-type': 'application/json',
      'authorization': "Bearer $token",
    };
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: commonHeaders, body: body);
      final http.Response response = await http.patch(
        uri,
        headers: commonHeaders,
        body: jsonEncode(body),
      );
      _logResponse(response: response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['message'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return HttpNetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  // DELETE request (named param for consistency)
  Future<HttpNetworkResponse> deleteRequest({required String url}) async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    Map<String, String> commonHeaders = {
      'content-type': 'application/json',
      'authorization': "Bearer $token",
    };
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, headers: commonHeaders);
      final http.Response response = await http.delete(uri, headers: commonHeaders);
      _logResponse(response: response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: 'Un Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return HttpNetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: responseBody['message'] ?? _defaultErrorMsg,
        );
      }
    } on Exception catch (e) {
      return HttpNetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _logRequest({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    final String message = '''
    URL -> $url
    HEADERS -> $headers
    BODY -> $body
    ''';
    _logger.i(message);
  }

  void _logResponse({required http.Response response}) {
    final String message = '''
    URL -> ${response.request?.url}
    HEADERS -> ${response.request?.headers}
    BODY -> ${response.body}
    ''';
    _logger.i(message);
  }
}

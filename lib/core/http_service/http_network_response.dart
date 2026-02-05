part of 'http_network_client.dart';

class HttpNetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final Map<String, dynamic>? responseData;
  final String? errorMessage;

  HttpNetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    this.responseData,
    this.errorMessage,
  });
}

import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://13.204.75.28:5056"));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
        options: Options(
          headers: {"accept": "*/*", "Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Login failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error logging in: $e");
    }
  }
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'endpoints.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: Urls.baseUrl,
        connectTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 15),
        headers: {"Content-Type": "application/json", "accept": "*/*"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString("accessToken");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.remove("accessToken");
            });
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get client => dio;
}

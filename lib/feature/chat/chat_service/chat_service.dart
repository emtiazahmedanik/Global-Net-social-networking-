// ignore_for_file: library_prefixes
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  IO.Socket? socket;

  var token = ''.obs;

  Future<void> getToken() async {
    String accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';
    token.value = accessToken; // ❗ JWT only (no "Bearer")
    if (kDebugMode) {
      print("📌 Socket Token Loaded: ${token.value}");
    }
  }

  final String baseUrl = Urls.socketUrl; // MUST be ws://server:port/chat

  void connect() {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setPath('/socket.io/') // ✅ required by backend
          .setAuth({'token': token.value}) // ✅ correct auth format
          .build(),
    );

    socket?.onConnect((_) => debugPrint("✅ Connected to chat socket"));
    socket?.onDisconnect((_) => debugPrint("❌ Disconnected from chat socket"));
    socket?.onError((error) => debugPrint("⚠️ Socket Error: $error"));
  }

  void emit(String event, dynamic data, {Function(dynamic)? ack}) {
    if (ack != null) {
      socket?.emitWithAck(event, data, ack: ack);
      debugPrint('sent to server');
    } else {
      socket?.emit(event, data);
      debugPrint('sent to server');

    }
  }

  void on(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }

  void onError(Function(dynamic) callback) {
    socket?.onError(callback);
  }

  void dispose() {
    socket?.dispose();
  }
}

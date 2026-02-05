// ignore_for_file: library_prefixes

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CallService extends GetxService {
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();

  IO.Socket? socket;
  var token = ''.obs;
  var isConnected = false.obs;

  final String baseUrl = Urls.callSocketUrl;
  
  Future<void> init() async {
    await getToken();
    connect();
  }

  Future<void> getToken() async {
    String accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';
    token.value = accessToken;
    if (kDebugMode) {
      print("📌 Call Socket Token Loaded: ${token.value}");
    }
  }

  void connect() {
    if (socket?.connected == true) {
      debugPrint("⚠️ Socket already connected");
      return;
    }

    socket = IO.io(
      'http://13.204.75.28:5056/realtime-call',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()              // ✅ Like SocketService
          .enableForceNew()                 // ✅ Like SocketService
          .setAuth({
            'token': token.value,           // ✅ Use 'token', not 'Authorization'
          })
          .setExtraHeaders({
            'Authorization': 'Bearer ${token.value}',  // ✅ Add Bearer here
          })
          .build(),
    );

    _setupListeners();
  }

  void _setupListeners() {
    socket?.onConnect((_) {
      isConnected.value = true;
      debugPrint("✅ Connected to call socket");
      debugPrint("📌 Socket ID: ${socket?.id}");
    });

    socket?.onDisconnect((_) {
      isConnected.value = false;
      debugPrint("❌ Disconnected from call socket");
    });

    socket?.onConnectError((error) {
      isConnected.value = false;
      debugPrint("⚠️ Call Socket Connect Error: $error");
    });

    socket?.onError((error) {
      debugPrint("⚠️ Call Socket Error: $error");
    });

    // ✅ Add incoming call listener here
    socket?.on('incoming-call', (data) {
      if (kDebugMode) {
        print('📞 Incoming Call: $data');
      }
      // _handleIncomingCall(data);
    });
  }

  // void _handleIncomingCall(dynamic data) {
  //   Get.to(() => IncomingCallScreen());
  //   // Handle incoming call logic
  //   if (kDebugMode) {
  //     print('Processing incoming call: $data');
  //   }
  //   // Navigate to incoming call screen or trigger notification
  // }

  void emit(String event, dynamic data, {Function(dynamic)? ack}) {
    if (socket?.connected != true) {
      debugPrint("⚠️ Socket not connected. Cannot emit: $event");
      return;
    }

    if (ack != null) {
      socket?.emitWithAck(event, data, ack: ack);
    } else {
      socket?.emit(event, data);
    }
    debugPrint('📤 Sent to server: $event');
  }

  void on(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }

  void off(String event) {
    socket?.off(event);
  }

  void reconnect() {
    disconnect();
    connect();
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    isConnected.value = false;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
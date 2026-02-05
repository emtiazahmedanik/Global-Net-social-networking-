// ignore_for_file: library_prefixes

import 'package:flutter/foundation.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/feature/notification/controller/notification_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  final isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  
  Future<SocketService> init() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    
    _initializeSocket(token ?? '');
    return this;
  }
  
  void _initializeSocket(String jwtToken) {
    socket = IO.io(
      Urls.notificationSocketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableForceNew()
          .setAuth({
            'token': jwtToken,
          })
          .setExtraHeaders({
            'Authorization': 'Bearer $jwtToken',
          })
          .build(),
    );
    
    _setupListeners();
  }
  
  void _setupListeners() {
    // Connection events
    socket.onConnect((_) {
      if (kDebugMode) {
        print('✅ NotificationSocket connected successfully');
      }
      isConnected.value = true;
    });
    
    socket.onConnectError((data) {
      if (kDebugMode) {
        print('❌ NotificationSocket Connection error: $data');
      }
      isConnected.value = false;
    });
    
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('⚠️ NotificationSocket Socket disconnected');
      }
      isConnected.value = false;
    });
    
    socket.onError((data) {
      if (kDebugMode) {
        print('❌ NotificationSocket Socket error: $data');
      }
    });
    
    // Notification event listeners
    _setupNotificationListeners();
  }
  
  void _setupNotificationListeners() {
    // Community notifications
    socket.on('community.create', (data) {
      debugPrint('📬 Received community.create notification $data');
      _handleNotification('community.create', data);
      
    });
    
    // NGO notifications
    socket.on('ngo.create', (data) {
      debugPrint('📬 Received ngo.create notification $data');
      _handleNotification('ngo.create', data);
    });
    
    // Post notifications
    socket.on('post.create', (data) {
      _handleNotification('post.create', data);
    });
    
    // CapLevel notifications
    socket.on('caplevel.create', (data) {
      _handleNotification('caplevel.create', data);
    });
    
    // Custom notifications
    socket.on('custom.create', (data) {
      _handleNotification('custom.create', data);
    });
    
    // Comment notifications (if needed)
    socket.on('comment.create', (data) {
      _handleNotification('comment.create', data);
    });
    
    // Message notifications (if needed)
    socket.on('message.create', (data) {
      _handleNotification('message.create', data);
    });
  }
  
  void _handleNotification(String type, dynamic data) {
    if (kDebugMode) {
      print('📬 Received notification: $type');
    }
    if (kDebugMode) {
      print('Data: $data');
    }
    
    // Dispatch to notification controller
    if (Get.isRegistered<AllNotificationController>()) {
      Get.find<AllNotificationController>().addNotification(type, data);
    }else{
      Get.put(AllNotificationController()).addNotification(type, data);
    }
  }
  
  void reconnect(String jwtToken) {
    disconnect();
    _initializeSocket(jwtToken);
  }

  
  void disconnect() {
    socket.disconnect();
    socket.dispose();
    isConnected.value = false;
  }
  
  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}

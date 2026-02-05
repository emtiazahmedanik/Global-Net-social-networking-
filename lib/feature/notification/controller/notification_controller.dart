import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jdadzok/feature/notification/model/notificationi_model.dart';

class AllNotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  
  @override
  void onInit() {
    super.onInit();
    _initializeLocalNotifications();
    _loadNotificationsFromStorage();
  }
  
  Future<void> _initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization (no callback needed for newer versions)
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
    
    // Request permissions for iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (kDebugMode) {
      print('Notification received: $title - $body');
    }
  }
  
  void onSelectNotification(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null && payload.isNotEmpty) {
      if (kDebugMode) {
        print('Notification tapped: $payload');
      }
      // Handle notification tap
      try {
        if (notifications.isEmpty) {
          if (kDebugMode) {
            print('No notifications available');
          }
          return;
        }
        
        final notification = notifications.firstWhereOrNull(
          (n) => n.id == payload,
        );
        
        if (notification != null) {
          _handleNotificationTap(notification);
        } else {
          if (kDebugMode) {
            print('Notification not found: $payload');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error handling notification tap: $e');
        }
      }
    }
  }
  
  void addNotification(String type, dynamic data) {
    try {
      final notification = NotificationModel.fromJson(
        type,
        data is Map<String, dynamic> ? data : {},
      );
      
      notifications.insert(0, notification);
      unreadCount.value++;
      
      // Show real notification
      _showSystemNotification(notification);
      
      // Save to storage
      //_saveNotificationsToStorage();
      
    } catch (e) {
      if (kDebugMode) {
        print('Error adding notification: $e');
      }
    }
  }
  
  Future<void> _showSystemNotification(NotificationModel notification) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );
      
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      
      await flutterLocalNotificationsPlugin.show(
        notification.id.hashCode,
        notification.title,
        notification.message,
        platformChannelSpecifics,
        payload: notification.id,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing notification: $e');
      }
    }
  }
  
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      unreadCount.value = (unreadCount.value - 1).clamp(0, notifications.length);
      _saveNotificationsToStorage();
    }
  }
  
  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    unreadCount.value = 0;
    _saveNotificationsToStorage();
  }
  
  void deleteNotification(String notificationId) {
    try {
      final notification = notifications.firstWhereOrNull(
        (n) => n.id == notificationId,
      );
      
      if (notification != null) {
        if (!notification.isRead) {
          unreadCount.value--;
        }
        notifications.removeWhere((n) => n.id == notificationId);
        _saveNotificationsToStorage();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting notification: $e');
      }
    }
  }
  
  void clearAll() {
    notifications.clear();
    unreadCount.value = 0;
    _saveNotificationsToStorage();
  }
  
  List<NotificationModel> getUnreadNotifications() {
    return notifications.where((n) => !n.isRead).toList();
  }
  
  List<NotificationModel> getNotificationsByType(String type) {
    return notifications.where((n) => n.type == type).toList();
  }
  
  void _handleNotificationTap(NotificationModel notification) {
    markAsRead(notification.id);
    
    // Navigate based on notification type
    switch (notification.type) {
      case 'community.create':
        final communityId = notification.meta['communityId'];
        if (communityId != null) {
          // Navigate to community details
          // Get.toNamed('/community/$communityId');
          if (kDebugMode) {
            print('Navigate to community: $communityId');
          }
        }
        break;
      case 'ngo.create':
        final ngoId = notification.meta['ngoId'];
        if (ngoId != null) {
          // Navigate to NGO details
          // Get.toNamed('/ngo/$ngoId');
          if (kDebugMode) {
            print('Navigate to NGO: $ngoId');
          }
        }
        break;
      case 'post.create':
        final postId = notification.meta['postId'];
        if (postId != null) {
          // Navigate to post details
          // Get.toNamed('/post/$postId');
          if (kDebugMode) {
            print('Navigate to post: $postId');
          }
        }
        break;
      case 'message.create':
        final fromUserId = notification.meta['fromUserId'];
        if (fromUserId != null) {
          // Navigate to chat
          // Get.toNamed('/chat/$fromUserId');
          if (kDebugMode) {
            print('Navigate to chat: $fromUserId');
          }
        }
        break;
      default:
        // Open notifications screen
        Get.toNamed('/notifications');
    }
  }
  
  
  Future<void> _saveNotificationsToStorage() async {
    // Implement local storage using GetStorage, SharedPreferences, or Hive
    // Example with GetStorage:
    // final storage = GetStorage();
    // final notificationsJson = notifications.map((n) => {
    //   'type': n.type,
    //   'title': n.title,
    //   'message': n.message,
    //   'createdAt': n.createdAt.toIso8601String(),
    //   'meta': n.meta,
    //   'isRead': n.isRead,
    //   'id': n.id,
    // }).toList();
    // await storage.write('notifications', notificationsJson);
    if (kDebugMode) {
      print('💾 Saving notifications to storage');
    }
  }
  
  Future<void> _loadNotificationsFromStorage() async {
    // Implement loading from local storage
    // Example with GetStorage:
    // final storage = GetStorage();
    // final notificationsJson = storage.read<List>('notifications') ?? [];
    // notifications.value = notificationsJson.map((json) {
    //   return NotificationModel(
    //     type: json['type'],
    //     title: json['title'],
    //     message: json['message'],
    //     createdAt: DateTime.parse(json['createdAt']),
    //     meta: json['meta'],
    //     isRead: json['isRead'],
    //     id: json['id'],
    //   );
    // }).toList();
    // unreadCount.value = notifications.where((n) => !n.isRead).length;
    if (kDebugMode) {
      print('📂 Loading notifications from storage');
    }
  }
}
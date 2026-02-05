class NotificationModel {
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final Map<String, dynamic> meta;
  final bool isRead;
  final String id;
  
  NotificationModel({
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.meta,
    this.isRead = false,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  
  factory NotificationModel.fromJson(String type, Map<String, dynamic> json) {
    return NotificationModel(
      type: type,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      meta: json['meta'] ?? {},
    );
  }
  
  NotificationModel copyWith({
    String? type,
    String? title,
    String? message,
    DateTime? createdAt,
    Map<String, dynamic>? meta,
    bool? isRead,
    String? id,
  }) {
    return NotificationModel(
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      meta: meta ?? this.meta,
      isRead: isRead ?? this.isRead,
      id: id ?? this.id,
    );
  }
  
  // Get icon based on notification type
  String getIcon() {
    switch (type) {
      case 'community.create':
        return '🏘️';
      case 'ngo.create':
        return '🤝';
      case 'post.create':
        return '📝';
      case 'caplevel.create':
        return '⭐';
      case 'custom.create':
        return '📢';
      case 'comment.create':
        return '💬';
      case 'message.create':
        return '✉️';
      default:
        return '🔔';
    }
  }
  
  // Get readable type name
  String getTypeName() {
    switch (type) {
      case 'community.create':
        return 'Community';
      case 'ngo.create':
        return 'NGO';
      case 'post.create':
        return 'Post';
      case 'caplevel.create':
        return 'CapLevel';
      case 'custom.create':
        return 'Announcement';
      case 'comment.create':
        return 'Comment';
      case 'message.create':
        return 'Message';
      default:
        return 'Notification';
    }
  }
  
  // Get time ago string
  String getTimeAgo() {
    final difference = DateTime.now().difference(createdAt);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}
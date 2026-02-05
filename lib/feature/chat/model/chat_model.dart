class ChatModel {
  final String id;
  final String name;
  final String profileImage;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });
}

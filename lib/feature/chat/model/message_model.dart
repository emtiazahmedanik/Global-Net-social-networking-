class MessageModel {
  final String content;
  final String time;
  final String mediaUrl;
  final String mediaType;
  final String senderId;

  MessageModel({
    required this.content,
    required this.time,
    required this.mediaType,
    required this.mediaUrl,
    required this.senderId
  });

  factory MessageModel.fromJson(dynamic json) {
    return MessageModel(
      content: json['content'] ?? '',
      time: json['createdAt'],
      mediaType: json['mediaType'] ??'',
      mediaUrl: json['mediaUrl'] ?? '',
      senderId: json['sender']['id'] ?? ''
    );
  }
}

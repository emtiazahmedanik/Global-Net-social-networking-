class ParticipentListModel {
  final List<Participents> participent;
  final LastMessage? lastMessage;

  ParticipentListModel({required this.participent, this.lastMessage});

  factory ParticipentListModel.fromJson(dynamic json, String currentUserId) {
    List<Participents> participantsList = [];

    if (json['participants'] != null) {
      participantsList = (json['participants'] as List)
          .map((v) => Participents.fromJson(v))
          .where((p) => p.userId != currentUserId) // 👈 REMOVE logged-in user
          .toList();
    }

    return ParticipentListModel(
      participent: participantsList,
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
    );
  }
}

class Participents {
  final String chatId;
  final String userId;
  final String email;
  final String name;
  final String avatarUrl;

  Participents({
    required this.chatId,
    required this.userId,
    required this.email,
    required this.name,
    required this.avatarUrl,
  });

  factory Participents.fromJson(dynamic json) {
    return Participents(
      chatId: json['chatId'] ?? "",
      userId: json['userId'] ?? "",
      email: json['user']['email'] ?? "",
      name: json['user']['profile']['name'] ?? "",
      avatarUrl: json['user']['profile']['avatarUrl'] ?? "",
    );
  }
}

class LastMessage {
  final String content;
  final String mediaUrl;
  final String mediaType;
  final String createdAt;

  LastMessage({
    required this.content,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
  });

  factory LastMessage.fromJson(dynamic json) {
    return LastMessage(
      content: json['content'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

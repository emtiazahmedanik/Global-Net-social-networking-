class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final String createdAt;
  final UserModel sender;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    required this.sender,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      status: json['status'],
      createdAt: json['createdAt'],
      sender: UserModel.fromJson(json['sender']),
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final ProfileModel profile;

  UserModel({
    required this.id,
    required this.email,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      profile: ProfileModel.fromJson(json['profile']),
    );
  }
}

class ProfileModel {
  final String name;
  final String? avatarUrl;

  ProfileModel({required this.name, this.avatarUrl});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

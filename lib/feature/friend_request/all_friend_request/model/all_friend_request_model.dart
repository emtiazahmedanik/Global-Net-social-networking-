class AllFriendRequestModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  AllFriendRequestModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory AllFriendRequestModel.fromJson(Map<String, dynamic> json) {
    return AllFriendRequestModel(
      id: json["id"],
      name: json["profile"]["name"],
      email: json["email"],
      avatarUrl: json["profile"]["avatarUrl"],
    );
  }
}

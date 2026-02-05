class TrendingDataModel {
  String? id;
  String? type;
  String? name;
  String? username;
  String? title;
  String? avatarUrl;
  int? followersCount;
  String? createdAt;

  TrendingDataModel({
    this.id,
    this.type,
    this.name,
    this.username,
    this.title,
    this.avatarUrl,
    this.followersCount,
    this.createdAt,
  });

  factory TrendingDataModel.fromJson(Map<String, dynamic> json) {
    return TrendingDataModel(
      id: json['id']?.toString(),
      type: json['type']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      title: json['title']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      followersCount: json['followersCount'] is int
          ? json['followersCount']
          : int.tryParse(json['followersCount']?.toString() ?? '0'),
      createdAt: json['createdAt']?.toString(),
    );
  }
}

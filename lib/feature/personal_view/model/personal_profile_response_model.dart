class PersonalProfileResponseModel {
  final bool success;
  final String message;
  final ProfileData? data;

  PersonalProfileResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory PersonalProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonalProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final String id;
  final String userId;
  final String name;
  final String username;
  final String? title;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final String? location;
  final bool isToggleNotification;
  final String? dateOfBirth;
  final String? gender;
  final String? experience;
  final int followersCount;
  final int followingCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserData? user;

  ProfileData({
    required this.id,
    required this.userId,
    required this.name,
    required this.username,
    this.title,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.location,
    required this.isToggleNotification,
    this.dateOfBirth,
    this.gender,
    this.experience,
    required this.followersCount,
    required this.followingCount,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      title: json['title'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      location: json['location'],
      isToggleNotification: json['isToggleNotification'] ?? false,
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      experience: json['experience'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }


}

class UserData {
  final String id;
  final String email;
  final String authProvider;
  final bool isVerified;
  final String role;
  final String capLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.email,
    required this.authProvider,
    required this.isVerified,
    required this.role,
    required this.capLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      authProvider: json['authProvider'] ?? '',
      isVerified: json['isVerified'] ?? false,
      role: json['role'] ?? '',
      capLevel: json['capLevel'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }


}

class PublicProfileResponse {
  final bool success;
  final String message;
  final PublicProfileData data;

  PublicProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PublicProfileResponse.fromJson(Map<String, dynamic> json) {
    return PublicProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PublicProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class PublicProfileData {
  final String id;
  final String email;
  final String authProvider;
  final bool isVerified;
  final String role;
  final String capLevel;
  final String createdAt;
  final String updatedAt;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final ProfileInfo profile;
  final dynamic about;

  PublicProfileData({
    required this.id,
    required this.email,
    required this.authProvider,
    required this.isVerified,
    required this.role,
    required this.capLevel,
    required this.createdAt,
    required this.updatedAt,
    this.stripeAccountId,
    this.stripeCustomerId,
    required this.profile,
    this.about,
  });

  factory PublicProfileData.fromJson(Map<String, dynamic> json) {
    return PublicProfileData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      authProvider: json['authProvider'] ?? '',
      isVerified: json['isVerified'] ?? false,
      role: json['role'] ?? '',
      capLevel: json['capLevel'] ?? 'NONE',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      stripeAccountId: json['stripeAccountId'],
      stripeCustomerId: json['stripeCustomerId'],
      profile: ProfileInfo.fromJson(json['profile'] ?? {}),
      about: json['about'],
    );
  }
}

class ProfileInfo {
  final String id;
  final String userId;
  final String name;
  final String username;
  final String? title;
  final String? bio;
  final String avatarUrl;
  final String coverUrl;
  final String? location;
  final int balance;
  final bool isToggleNotification;
  final String? dateOfBirth;
  final String? gender;
  final String? experience;
  final int followersCount;
  final int followingCount;
  final String createdAt;
  final String updatedAt;

  ProfileInfo({
    required this.id,
    required this.userId,
    required this.name,
    required this.username,
    this.title,
    this.bio,
    required this.avatarUrl,
    required this.coverUrl,
    this.location,
    required this.balance,
    required this.isToggleNotification,
    this.dateOfBirth,
    this.gender,
    this.experience,
    required this.followersCount,
    required this.followingCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      title: json['title'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      location: json['location'],
      balance: json['balance'] ?? 0,
      isToggleNotification: json['isToggleNotification'] ?? false,
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      experience: json['experience'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

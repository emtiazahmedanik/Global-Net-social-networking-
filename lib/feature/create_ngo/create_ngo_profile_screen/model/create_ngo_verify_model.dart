class OrganizationModel {
  final String id;
  final String ownerId;
  final DateTime? foundationDate;
  final String? type; // communityType or ngoType
  final int? likes;
  final bool? isVerified;
  final String? capLevel;
  final bool? isToggleNotification;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProfileModel? profile;
  final AboutModel? about;
  final bool isNgo; // convenience flag

  OrganizationModel({
    required this.id,
    required this.ownerId,
    this.foundationDate,
    this.type,
    this.likes,
    this.isVerified,
    this.capLevel,
    this.isToggleNotification,
    this.createdAt,
    this.updatedAt,
    this.profile,
    this.about,
    this.isNgo = false,
  });

  factory OrganizationModel.fromJson(
    Map<String, dynamic> json, {
    required bool isNgo,
  }) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v as String);
      } catch (e) {
        return null;
      }
    }

    return OrganizationModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      foundationDate: parseDate(json['foundationDate']),
      type: (isNgo ? json['ngoType'] : json['communityType'])?.toString(),
      likes: (json['likes'] is int)
          ? json['likes']
          : int.tryParse(json['likes']?.toString() ?? '0'),
      isVerified: json['isVerified'] as bool? ?? false,
      capLevel: json['capLevel']?.toString(),
      isToggleNotification: json['isToggleNotification'] as bool? ?? false,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      profile: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      about: json['about'] != null
          ? AboutModel.fromJson(json['about'] as Map<String, dynamic>)
          : null,
      isNgo: isNgo,
    );
  }

  static List<OrganizationModel> listFromJson(
    List<dynamic> list, {
    required bool isNgo,
  }) {
    return list
        .map(
          (e) => OrganizationModel.fromJson(
            e as Map<String, dynamic>,
            isNgo: isNgo,
          ),
        )
        .toList();
  }
}

class ProfileModel {
  final String? id;
  final String? name;
  final String? username;
  final String? title;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final String? location;
  final int? balance;
  final int? followersCount;
  final int? followingCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    this.id,
    this.name,
    this.username,
    this.title,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.location,
    this.balance,
    this.followersCount,
    this.followingCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v as String);
      } catch (e) {
        return null;
      }
    }

    return ProfileModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      title: json['title']?.toString(),
      bio: json['bio']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      coverUrl: json['coverUrl']?.toString(),
      location: json['location']?.toString(),
      balance: json['balance'] is int
          ? json['balance'] as int
          : int.tryParse(json['balance']?.toString() ?? '0'),
      followersCount: json['followersCount'] is int
          ? json['followersCount'] as int
          : int.tryParse(json['followersCount']?.toString() ?? '0'),
      followingCount: json['followingCount'] is int
          ? json['followingCount'] as int
          : int.tryParse(json['followingCount']?.toString() ?? '0'),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }
}

class AboutModel {
  final String? id;
  final String? location;
  final DateTime? foundingDate;
  final String? mission;
  final String? website;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AboutModel({
    this.id,
    this.location,
    this.foundingDate,
    this.mission,
    this.website,
    this.createdAt,
    this.updatedAt,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v as String);
      } catch (e) {
        return null;
      }
    }

    return AboutModel(
      id: json['id']?.toString(),
      location: json['location']?.toString(),
      foundingDate: parseDate(json['foundingDate']),
      mission: json['mission']?.toString(),
      website: json['website']?.toString(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }
}

// lib/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart

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
  final bool isNgo;

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

  factory OrganizationModel.fromJson(Map<String, dynamic> json, {bool isNgo = false}) {
    return OrganizationModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      foundationDate: json['foundationDate'] != null ? DateTime.parse(json['foundationDate'] as String) : null,
      type: isNgo ? (json['ngoType'] as String?) : (json['communityType'] as String?),
      likes: json['likes'] is int ? json['likes'] as int : int.tryParse('${json['likes']}'),
      isVerified: json['isVerified'] as bool?,
      capLevel: json['capLevel'] as String?,
      isToggleNotification: json['isToggleNotification'] as bool?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      profile: json['profile'] != null ? ProfileModel.fromJson(json['profile'] as Map<String, dynamic>) : null,
      about: json['about'] != null ? AboutModel.fromJson(json['about'] as Map<String, dynamic>) : null,
      isNgo: isNgo,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "id": id,
      "ownerId": ownerId,
      "foundationDate": foundationDate?.toIso8601String(),
      "likes": likes,
      "isVerified": isVerified,
      "capLevel": capLevel,
      "isToggleNotification": isToggleNotification,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "profile": profile?.toJson(),
      "about": about?.toJson(),
    };
    if (isNgo) {
      map['ngoType'] = type;
    } else {
      map['communityType'] = type;
    }
    return map;
  }

  static List<OrganizationModel> listFromJson(List<dynamic> list, {bool isNgo = false}) {
    return list.map((e) => OrganizationModel.fromJson(e as Map<String, dynamic>, isNgo: isNgo)).toList();
  }
}

class ProfileModel {
  final String id;
  final String? parentId; // communityId or ngoId
  final String? name;
  final String? username;
  final String? title;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final String? location;
  final num? balance;
  final int? followersCount;
  final int? followingCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    required this.id,
    this.parentId,
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
    final parentId = json['communityId'] ?? json['ngoId'];
    return ProfileModel(
      id: json['id'] as String,
      parentId: parentId as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      location: json['location'] as String?,
      balance: json['balance'],
      followersCount: json['followersCount'] is int ? json['followersCount'] as int : int.tryParse('${json['followersCount']}'),
      followingCount: json['followingCount'] is int ? json['followingCount'] as int : int.tryParse('${json['followingCount']}'),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "username": username,
      "title": title,
      "bio": bio,
      "avatarUrl": avatarUrl,
      "coverUrl": coverUrl,
      "location": location,
      "balance": balance,
      "followersCount": followersCount,
      "followingCount": followingCount,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class AboutModel {
  final String id;
  final String? parentId;
  final String? location;
  final DateTime? foundingDate;
  final String? mission;
  final String? website;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AboutModel({
    required this.id,
    this.parentId,
    this.location,
    this.foundingDate,
    this.mission,
    this.website,
    this.createdAt,
    this.updatedAt,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    final parentId = json['communityId'] ?? json['ngoId'];
    return AboutModel(
      id: json['id'] as String,
      parentId: parentId as String?,
      location: json['location'] as String?,
      foundingDate: json['foundingDate'] != null ? DateTime.parse(json['foundingDate'] as String) : null,
      mission: json['mission'] as String?,
      website: json['website'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "location": location,
      "foundingDate": foundingDate?.toIso8601String(),
      "mission": mission,
      "website": website,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

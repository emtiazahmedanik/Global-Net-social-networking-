class SingleProductResponse {
  final bool? success;
  final String? message;
  final ProductData? data;

  SingleProductResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SingleProductResponse.fromJson(Map<String, dynamic> json) {
    return SingleProductResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] != null && json['data'] is Map<String, dynamic>)
          ? ProductData.fromJson(json['data'])
          : null,
    );
  }
}

class ProductData {
  final String? id;
  final String? sellerId;
  final String? categoryId;
  final String? title;
  final String? description;
  final num? price;
  final String? location;
  final num? availability;
  final List<String>? digitalFileUrl;
  final num? spent;
  final num? promotionFee;
  final bool? isVisible;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? orders;
  final Seller? seller;

  ProductData({
    this.id,
    this.sellerId,
    this.categoryId,
    this.title,
    this.description,
    this.price,
    this.location,
    this.availability,
    this.digitalFileUrl,
    this.spent,
    this.promotionFee,
    this.isVisible,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orders,
    this.seller,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      sellerId: json['sellerId'],
      categoryId: json['categoryId'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      location: json['location'],
      availability: json['availability'],
      digitalFileUrl: json['digitalFileUrl'] is List
          ? List<String>.from(json['digitalFileUrl'])
          : [],
      spent: json['spent'],
      promotionFee: json['promotionFee'],
      isVisible: json['isVisible'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      orders: json['orders'] is List ? json['orders'] : [],
      seller: (json['seller'] != null && json['seller'] is Map<String, dynamic>)
          ? Seller.fromJson(json['seller'])
          : null,
    );
  }
}

class Seller {
  final String? id;
  final String? email;
  final String? password;
  final String? authProvider;
  final bool? isVerified;
  final String? role;
  final String? capLevel;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final Profile? profile;
  final dynamic about;
  final Metrics? metrics;

  Seller({
    this.id,
    this.email,
    this.password,
    this.authProvider,
    this.isVerified,
    this.role,
    this.capLevel,
    this.createdAt,
    this.updatedAt,
    this.stripeAccountId,
    this.stripeCustomerId,
    this.profile,
    this.about,
    this.metrics,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      authProvider: json['authProvider'],
      isVerified: json['isVerified'],
      role: json['role'],
      capLevel: json['capLevel'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      stripeAccountId: json['stripeAccountId'],
      stripeCustomerId: json['stripeCustomerId'],

      // SAFE PARSING
      profile: (json['profile'] != null && json['profile'] is Map<String, dynamic>)
          ? Profile.fromJson(json['profile'])
          : null,

      about: json['about'],

      metrics: (json['metrics'] != null && json['metrics'] is Map<String, dynamic>)
          ? Metrics.fromJson(json['metrics'])
          : null,
    );
  }
}

class Profile {
  final String? id;
  final String? userId;
  final String? name;
  final String? username;
  final String? title;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final String? location;
  final num? balance;
  final bool? isToggleNotification;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? experience;
  final num? followersCount;
  final num? followingCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profile({
    this.id,
    this.userId,
    this.name,
    this.username,
    this.title,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.location,
    this.balance,
    this.isToggleNotification,
    this.dateOfBirth,
    this.gender,
    this.experience,
    this.followersCount,
    this.followingCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      username: json['username'],
      title: json['title'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      location: json['location'],
      balance: json['balance'],
      isToggleNotification: json['isToggleNotification'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      experience: json['experience'],
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class Metrics {
  final String? id;
  final String? userId;
  final num? totalPosts;
  final num? totalComments;
  final num? totalLikes;
  final num? totalShares;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalEarnings;
  final num? currentMonthEarnings;
  final num? volunteerHours;
  final num? completedProjects;
  final num? activityScore;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Metrics({
    this.id,
    this.userId,
    this.totalPosts,
    this.totalComments,
    this.totalLikes,
    this.totalShares,
    this.totalFollowers,
    this.totalFollowing,
    this.totalEarnings,
    this.currentMonthEarnings,
    this.volunteerHours,
    this.completedProjects,
    this.activityScore,
    this.lastUpdated,
    this.createdAt,
    this.updatedAt,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      id: json['id'],
      userId: json['userId'],
      totalPosts: json['totalPosts'],
      totalComments: json['totalComments'],
      totalLikes: json['totalLikes'],
      totalShares: json['totalShares'],
      totalFollowers: json['totalFollowers'],
      totalFollowing: json['totalFollowing'],
      totalEarnings: json['totalEarnings'],
      currentMonthEarnings: json['currentMonthEarnings'],
      volunteerHours: json['volunteerHours'],
      completedProjects: json['completedProjects'],
      activityScore: json['activityScore'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

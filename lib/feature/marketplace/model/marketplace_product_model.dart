class MarketplaceProductModel {
  final bool success;
  final String message;
  final List<MarketplaceProduct> data;

  MarketplaceProductModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MarketplaceProductModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceProductModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? (json['data'] as List).map((e) => MarketplaceProduct.fromJson(e)).toList()
          : [],
    );
  }


}

class MarketplaceProduct {
  final String id;
  final String sellerId;
  final String categoryId;
  final String title;
  final String description;
  final double price;
  final String location;
  final int availability;
  final List<dynamic> digitalFileUrl;
  final double spent;
  final double promotionFee;
  final bool isVisible;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Seller seller;

  MarketplaceProduct({
    required this.id,
    required this.sellerId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.availability,
    required this.digitalFileUrl,
    required this.spent,
    required this.promotionFee,
    required this.isVisible,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.seller,
  });

  factory MarketplaceProduct.fromJson(Map<String, dynamic> json) {
    return MarketplaceProduct(
      id: json["id"] ?? "",
      sellerId: json["sellerId"] ?? "",
      categoryId: json["categoryId"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      location: json["location"] ?? "",
      availability: json["availability"] ?? 0,
      digitalFileUrl: json["digitalFileUrl"] ?? [],
      spent: (json["spent"] ?? 0).toDouble(),
      promotionFee: (json["promotionFee"] ?? 0).toDouble(),
      isVisible: json["isVisible"] ?? false,
      status: json["status"] ?? "",
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      seller: Seller.fromJson(json["seller"]),
    );
  }

}

class Seller {
  final String id;
  final String email;
  final String password;
  final String authProvider;
  final bool isVerified;
  final String role;
  final String capLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  Seller({
    required this.id,
    required this.email,
    required this.password,
    required this.authProvider,
    required this.isVerified,
    required this.role,
    required this.capLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json["id"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      authProvider: json["authProvider"] ?? "",
      isVerified: json["isVerified"] ?? false,
      role: json["role"] ?? "",
      capLevel: json["capLevel"] ?? "",
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

}

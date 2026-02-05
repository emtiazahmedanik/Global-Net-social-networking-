class ProductModel {
  final String id;
  final String title;
  final int price;
  final String imageUrl;
  final String location;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.location,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'location': location,
      'category': category,
    };
  }
}

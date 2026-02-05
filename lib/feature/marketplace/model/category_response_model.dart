class CategoryResponse {
  final bool success;
  final String message;
  final List<CategoryModel> data;

  CategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'],
      message: json['message'],
      data: List<CategoryModel>.from(
        json['data'].map((x) => CategoryModel.fromJson(x)),
      ),
    );
  }
}
   

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

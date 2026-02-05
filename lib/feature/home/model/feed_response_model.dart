import 'package:flutter/foundation.dart';

class FeedResponse {
  final List<PostModel> data;
  final MetaData metadata;


  FeedResponse({required this.data,required this.metadata});

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      data: (json['data'] as List).map((e) => PostModel.fromJson(e)).toList(),
      metadata:MetaData.fromJson(json['metadata']) 
    );
  }
}

class PostModel {
  final String id;
  final String authorId;
  final String text;
  final List<String> mediaUrls;
  final String mediaType;
  final String visibility;
  final String postFrom;

  final String? categoryId;
  final String? communityId;
  final String? ngoId;
  final String? metadataId;

  final bool acceptVolunteer;
  final bool acceptDonation;

  final String createdAt;
  final String updatedAt;

  final AuthorModel author;
  final List<LikeModel> likes;
  final List<dynamic> shares;
  final List<TaggedUser> taggedUsers;
  final MetadataModel metadata;
  
  ValueNotifier<bool> isLiked;

  PostModel({
    required this.id,
    required this.authorId,
    required this.text,
    required this.mediaUrls,
    required this.mediaType,
    required this.visibility,
    required this.postFrom,
    required this.categoryId,
    required this.communityId,
    required this.ngoId,
    required this.metadataId,
    required this.acceptVolunteer,
    required this.acceptDonation,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.likes,
    required this.shares,
    required this.taggedUsers,
    required this.metadata,
    
    
  }): isLiked = ValueNotifier(false);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      authorId: json['authorId'],
      text: json['text'] ?? "",
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      mediaType: json['mediaType'] ?? "",
      visibility: json['visibility'] ?? "",
      postFrom: json['postFrom'] ?? "",

      categoryId: json['categoryId'] ?? '',
      communityId: json['communityId'] ?? '',
      ngoId: json['ngoId'] ?? '',
      metadataId: json['metadataId'] ?? '',

      acceptVolunteer: json['acceptVolunteer'] ?? false,
      acceptDonation: json['acceptDonation'] ?? false,

      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      metadata: MetadataModel.fromJson(json['metadata'] ?? {}),

      author: AuthorModel.fromJson(json['author']),
      likes: (json['likes'] as List ).map((e) => LikeModel.fromJson(e)).toList(),
      shares: json['shares'] ?? [],
      taggedUsers: (json['taggedUsers'] as List).map((e) => TaggedUser.fromJson(e)).toList(),
      
    );
  }
}

class LikeModel {

  final String likeId;
  final String userId;
  final String postId;
  final String commentId;
  final String createdAt;

  LikeModel({
    required this.likeId,
    required this.userId,
    required this.postId,
    required this.commentId,
    required this.createdAt,
  });

  factory LikeModel.fromJson(Map<String,dynamic> data) {
    
    return LikeModel(
      likeId: data['id'] ?? '',
      userId: data['userId'] ?? '',
      postId: data['postId'] ?? '',
      commentId: data['commentId'] ?? '',
      createdAt: data['createdAt'] ?? '',
      
    );
  }

  factory LikeModel.empty() {
    return LikeModel(
      likeId: '',
      userId: '',
      postId: '',
      commentId: '',
      createdAt: '',
    );
  }
}

class AuthorModel {
  final String id;
  final String email;
  final String name;
  final String avatarUrl;

  AuthorModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? "",
      avatarUrl: json['avatarUrl'] ?? "",
    );
  }
}

class MetaData {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  MetaData({this.page, this.limit, this.total, this.totalPages});

  MetaData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
  }

}

class TaggedUser {
  final String id;
  final String name;

  TaggedUser({
    required this.id,
    required this.name,
  });

  factory TaggedUser.fromJson(Map<String, dynamic> json) {
    return TaggedUser(
      id: json['user']['id'] ?? '',
      name: json['user']['profile']['name'] ?? ''
    );
  }
}

class MetadataModel {
  final String id;
  final String feelings;
  final String checkIn;


  MetadataModel({
    required this.id,
    required this.feelings,
    required this.checkIn,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      id: json['id'] ?? '',
      feelings: json['feelings'] ?? '',
      checkIn: json['checkIn'] ?? '',
    );
  }
}
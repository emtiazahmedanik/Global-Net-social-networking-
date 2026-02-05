class CommentResponseModel {
  String? id;
  String? postId;
  String? authorId;
  String? text;
  String? mediaUrl;
  String? mediaType;
  String? parentCommentId;
  String? createdAt;
  String? updatedAt;
  Author? author;
  //List<Null>? replies;
  //List<Null>? likes;

  CommentResponseModel({
    this.id,
    this.postId,
    this.authorId,
    this.text,
    this.mediaUrl,
    this.mediaType,
    this.parentCommentId,
    this.createdAt,
    this.updatedAt,
    this.author,
    //this.replies,
    //this.likes});
  });

  CommentResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    authorId = json['authorId'];
    text = json['text'];
    mediaUrl = json['mediaUrl'];
    mediaType = json['mediaType'];
    parentCommentId = json['parentCommentId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    // if (json['replies'] != null) {
    //   replies = <Null>[];
    //   json['replies'].forEach((v) {
    //     replies!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['likes'] != null) {
    //   likes = <Null>[];
    //   json['likes'].forEach((v) {
    //     likes!.add(new Null.fromJson(v));
    //   });
    // }
  }
}

class Author {
  String? id;
  String? email;
  String? password;
  String? authProvider;
  bool? isVerified;
  String? role;
  String? capLevel;
  String? createdAt;
  String? updatedAt;
  AuthorProfile? authorProfile;

  //Null? stripeAccountId;
  //Null? stripeCustomerId;

  Author({
    this.id,
    this.email,
    this.password,
    this.authProvider,
    this.isVerified,
    this.role,
    this.capLevel,
    this.createdAt,
    this.updatedAt,
    this.authorProfile,
    //this.stripeAccountId,
    //this.stripeCustomerId,
  });

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    authProvider = json['authProvider'];
    isVerified = json['isVerified'];
    role = json['role'];
    capLevel = json['capLevel'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    authorProfile = json['profile'] != null
        ? AuthorProfile.fromJson(json['profile'])
        : null;
    //stripeAccountId = json['stripeAccountId'];
    //stripeCustomerId = json['stripeCustomerId'];
  }
}

class AuthorProfile {
  final String name;
  final String avatarUrl;

  AuthorProfile({required this.name, required this.avatarUrl});

  factory AuthorProfile.fromJson(Map<String,dynamic> json) {
    return AuthorProfile(name: json['name'], avatarUrl: json['avatarUrl'] ?? '');
  }
}

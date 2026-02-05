class Post {
  final String id;
  final String authorName;
  final String authorImage;
  final String timeAgo;
  final String? title;
  final String? content;
  final String? postImage;
  final int likes;
  final int comments;
  final bool isVerified;
  final bool isLiked;
  final bool? capIcons;

  Post({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.timeAgo,
    this.title,
    this.content,
    this.postImage,
    required this.likes,
    required this.comments,
    this.isVerified = false,
    this.isLiked = false,
    this.capIcons,
  });
}

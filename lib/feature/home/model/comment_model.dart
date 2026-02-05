class Comment {
  final String id;
  final String authorName;
  final String authorImage;
  final String content;
  final String timeAgo;
  final int repliesCount;
  final bool hasReplies;

  Comment({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.content,
    required this.timeAgo,
    this.repliesCount = 0,
    this.hasReplies = false,
  });
}

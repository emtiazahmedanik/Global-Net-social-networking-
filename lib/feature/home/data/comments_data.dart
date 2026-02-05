import '../model/comment_model.dart';

class CommentsData {
  static final List<Comment> sampleComments = [
    Comment(
      id: '1',
      authorName: 'Eleanor Pena',
      authorImage: 'assets/images/profile_image_001.png',
      content: 'How neatly I write the...',
      timeAgo: '22h',
    ),
    Comment(
      id: '2',
      authorName: 'Leslie Alexander',
      authorImage: 'assets/images/profile_image_002.png',
      content: 'How neatly I write the...',
      timeAgo: '22h',
      hasReplies: true,
      repliesCount: 4,
    ),
    Comment(
      id: '3',
      authorName: 'Devon Lane',
      authorImage: 'assets/images/profile_image_003.png',
      content: 'How neatly I write the...',
      timeAgo: '22h',
    ),
    Comment(
      id: '4',
      authorName: 'Guy Hawkins',
      authorImage: 'assets/images/profile_image_004.png',
      content: 'How neatly I write the...',
      timeAgo: '22h',
    ),
    Comment(
      id: '5',
      authorName: 'Albert Flores',
      authorImage: 'assets/images/profile_image_005.png',
      content: 'How neatly I write the...',
      timeAgo: '22h',
      hasReplies: true,
      repliesCount: 4,
    ),
    Comment(
      id: '6',
      authorName: 'martini_rond',
      authorImage: 'assets/images/profile_image_006.png',
      content: 'How neatly I write the...',
      timeAgo: '22h',
    ),
  ];
}

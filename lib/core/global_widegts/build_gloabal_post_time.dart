  import 'package:flutter/material.dart';

Widget buidGlobalPostTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    String timeText;

    if (difference.inSeconds < 60) {
      timeText = "Just now";
    } else if (difference.inMinutes < 60) {
      timeText = "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      timeText = "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      timeText = "Yesterday";
    } else if (difference.inDays < 30) {
      timeText = "${difference.inDays} days ago";
    } else if (difference.inDays < 365) {
      timeText = "${(difference.inDays / 30).floor()} months ago";
    } else {
      timeText = "${(difference.inDays / 365).floor()} years ago";
    }

    return Text(
      timeText,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
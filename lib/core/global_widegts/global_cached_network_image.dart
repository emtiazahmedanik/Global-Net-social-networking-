// ignore_for_file: avoid_init_to_null

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget getCachedNetworkImage({required String imageUrl, double width = double.infinity, double? height = null}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    width: width,
    height: height,

    // Shimmer Placeholder
    placeholder: (context, url) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.grey.shade300),
    ),

    // Error Image
    errorWidget: (context, url, error) => Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    ),
  );
}

// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:jdadzok/core/style/global_text_style.dart';

class NGOCreatePostProfileRowWidget extends StatelessWidget {
  final bool isNgo;
  final String? name;
  final String? photo;
  const NGOCreatePostProfileRowWidget({super.key, required this.isNgo, required this.name, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(backgroundImage: photo != null ? NetworkImage(photo!) : null, radius: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? 'Organization Name',
              style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              spacing: 6,
              children: [
                Icon(Icons.group, size: 16),
                Text(
                  isNgo? "NGO" : "Community",
                  style: globalTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

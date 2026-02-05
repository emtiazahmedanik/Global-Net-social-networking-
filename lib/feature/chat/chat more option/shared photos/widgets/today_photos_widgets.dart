import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';

import 'fullscreen_image_view.dart';

class TodayPhotosWidgets extends StatelessWidget {
  const TodayPhotosWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Get.to(
                () => FullScreenImage(imagePath: ImagePath.todayphoto1),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  ImagePath.todayphoto1,
                  fit: BoxFit.cover,
                  height: 150,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => Get.to(
                () => FullScreenImage(imagePath: ImagePath.todayphoto2),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  ImagePath.todayphoto2,
                  fit: BoxFit.cover,
                  height: 150,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

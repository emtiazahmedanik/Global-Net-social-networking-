import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';

import 'fullscreen_image_view.dart';

class OldPhotosWidget extends StatelessWidget {
  const OldPhotosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(
                    () => FullScreenImage(imagePath: ImagePath.oldphoto1),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      ImagePath.oldphoto1,
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(
                    () => FullScreenImage(imagePath: ImagePath.oldphoto2),
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      ImagePath.oldphoto2,
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(
                    () => FullScreenImage(imagePath: ImagePath.oldphoto3),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      ImagePath.oldphoto3,
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(
                    () => FullScreenImage(imagePath: ImagePath.oldphoto4),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      ImagePath.oldphoto4,
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

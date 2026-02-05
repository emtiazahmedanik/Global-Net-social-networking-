import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';

class NGOCoverPhoto extends StatelessWidget {
  const NGOCoverPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final NgoMainProfileScreenController controller = Get.find();
    return Obx(() {
      final coverFile = controller.coverFile.value;
      final coverUrl = controller.org.value?.profile?.coverUrl;
      ImageProvider imageProvider;
      if (coverFile != null) {
        imageProvider = FileImage(coverFile);
      } else if (coverUrl != null && coverUrl.isNotEmpty) {
        imageProvider = NetworkImage(coverUrl);
      } else {
        imageProvider = AssetImage(ImagePath.ngoCoverImage);
      }

      return Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      );
    });
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/edit_profile/controller/edit_profile_screen_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoverPhoto extends StatelessWidget {
  CoverPhoto({super.key, this.imageUrl, this.fromPublicView});
  final String? imageUrl;
  final bool? fromPublicView;

  final EditProfileScreenController controller = Get.put(
    EditProfileScreenController(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// First priority -> FileImage (user selected new image)
      if (controller.coverImage.value != null) {
        return _coverWidget(
          child: Image.file(
            File(controller.coverImage.value!.path),
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
          ),
        );
      }

      /// 2nd -> profile data loading → show shimmer
      if (controller.profile.value == null) {
        return _shimmer();
      }

      if (fromPublicView != null && fromPublicView! == true) {
        debugPrint('ei je here image asche : $imageUrl');
        return _coverWidget(
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
            placeholder: (_, _) => _shimmer(),
            errorWidget: (_, _, _) =>
                Image.asset(ImagePath.ngoCoverImage, fit: BoxFit.cover),
          ),
        );
      }

      /// 3rd -> profile loaded
      final coverUrl = controller.profile.value?.data?.coverUrl;
      final hasNetwork = coverUrl != null && coverUrl.isNotEmpty;

      return _coverWidget(
        child: hasNetwork
            ? CachedNetworkImage(
                imageUrl: coverUrl,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
                placeholder: (_, _) => _shimmer(),
                errorWidget: (_, _, _) =>
                    Image.asset(ImagePath.ngoCoverImage, fit: BoxFit.cover),
              )
            : Image.asset(
                ImagePath.ngoCoverImage,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
      );
    });
  }

  Widget _coverWidget({required Widget child}) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: SizedBox(width: double.infinity, height: 170, child: child),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}

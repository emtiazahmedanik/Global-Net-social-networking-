import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:video_player/video_player.dart';
import '../../../theme/app_colors.dart';
import '../../../core/const/image_path.dart';
import '../../../core/const/icons_path.dart';
import '../controller/create_post_controller.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';
import '../widgets/post_options_modal.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CreatePostController controller = Get.put(CreatePostController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 38,
                          height: 38,
                          padding: EdgeInsets.all(7),
                          decoration: ShapeDecoration(
                            color: Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      const SizedBox(width: 86),

                      Text(
                        'Create Post',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  Obx(
                    () => GestureDetector(
                      onTap: controller.canPost ? controller.createPost : null,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: ShapeDecoration(
                          color: controller.canPost
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: Center(
                          child: controller.isPosting.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Post',
                                  textAlign: TextAlign.center,
                                  style: globalTextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      Obx(() {
                        if (controller.selectedFeeling.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final f = controller.selectedFeeling.value
                            .replaceAll('_', ' ')
                            .toLowerCase();
                        final label = f.isNotEmpty
                            ? '${f[0].toUpperCase()}${f.substring(1)}'
                            : controller.selectedFeeling.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.emoji_emotions,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      ' $label',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          controller.selectedFeeling.value = '',
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      GetBuilder<PersonalProfileViewController>(
                        init: PersonalProfileViewController(),
                        builder: (pc) {
                          final avatar =
                              pc.profile.value?.data?.avatarUrl ?? '';
                          final name =
                              pc.profile.value?.data?.name ??
                              pc.profile.value?.data?.username ??
                              'You';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: avatar.isNotEmpty
                                          ? NetworkImage(avatar)
                                                as ImageProvider
                                          : AssetImage(
                                              ImagePath.profileImage001,
                                            ),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.06,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            IconsPath.publicPrivacyIcon,
                                            width: 12,
                                            height: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Obx(
                                            () => SizedBox(
                                              height: 20,
                                              child: DropdownButton<PrivacyOption>(
                                                value: controller
                                                    .selectedPrivacy
                                                    .value,
                                                underline: const SizedBox(),
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 12,
                                                  color: Color(0xFF6B7280),
                                                ),
                                                iconSize: 12,
                                                style: const TextStyle(
                                                  color: Color(0xFF6B7280),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                dropdownColor: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: PrivacyOption.public,
                                                    child: Text('Public'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value:
                                                        PrivacyOption.followers,
                                                    child: Text('Followers'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value:
                                                        PrivacyOption.private,
                                                    child: Text('Private'),
                                                  ),
                                                  //const Text('Public'),
                                                ],
                                                onChanged:
                                                    (PrivacyOption? value) {
                                                      if (value != null) {
                                                        controller
                                                                .selectedPrivacy
                                                                .value =
                                                            value;
                                                      }
                                                    },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 100,
                          maxHeight: 300,
                        ),
                        child: TextField(
                          controller: controller.textController,
                          maxLines: null,
                          minLines: 5,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            hintText: "What's on your mind?",
                            hintStyle: TextStyle(
                              color: Color(0xFF6A6A6A),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.50,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Obx(() {
                        if (!controller.hasMedia.value) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Stack(
                            children: [
                              // MEDIA PREVIEW BLOCK
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    controller.mediaType.value ==
                                        MediaType.image
                                    ? Image.file(
                                        File(
                                          controller.selectedMediaPath.value,
                                        ),
                                        width: double.infinity,
                                        height: 223,
                                        fit: BoxFit.cover,
                                      )
                                    : controller.isVideoInitialized.value
                                    ? AspectRatio(
                                        aspectRatio: controller
                                            .videoController!
                                            .value
                                            .aspectRatio,
                                        child: VideoPlayer(
                                          controller.videoController!,
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 223,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                              ),

                              // Close button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: controller.removeMedia,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),

                              // Play button overlay for video
                              if (controller.mediaType.value == MediaType.video)
                                Positioned.fill(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller
                                            .videoController!
                                            .value
                                            .isPlaying) {
                                          controller.videoController!.pause();
                                        } else {
                                          controller.videoController!.play();
                                        }
                                      },
                                      child: Icon(
                                        controller
                                                .videoController!
                                                .value
                                                .isPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_fill,
                                        size: 60,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),

            Obx(
              () => PostOptionsModal(
                isCollapsed: controller.isModalCollapsed.value,
                onPhotoVideoTap: controller.pickPhotoVideo,
                onTagPeopleTap: controller.tagPeople,
                onFeelingActivityTap: controller.addFeelingActivity,
                onCheckInTap: controller.checkIn,
                onGifTap: controller.addGif,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

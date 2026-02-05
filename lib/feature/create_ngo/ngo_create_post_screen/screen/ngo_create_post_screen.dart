// lib/feature/create_ngo/ngo_create_post_screen/screen/ngo_create_post_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/core/global_widegts/screen_header_row.dart';
import 'package:jdadzok/feature/create_ngo/ngo_create_post_screen/controller/ngo_create_post_screen_controller.dart';
import 'package:jdadzok/feature/create_ngo/ngo_create_post_screen/widget/ngo_creat_post_bottom_category.dart';
import 'package:jdadzok/feature/create_ngo/ngo_create_post_screen/widget/ngo_create_post_profile_row_widget.dart';

/// Single screen used for both NGO and Community.
/// When using named routes, pass arguments:
///   Get.toNamed(AppRoute.NgoCreatePostScreen, arguments: {'isNgo': true, 'orgId': '...'});
class NgoCreatePostScreen extends StatelessWidget {
  final bool isNgo;
  final Map<String, dynamic>? nameAndPhoto;


  // create late controller field, we'll initialize in the constructor
  late final NgoCreatePostScreenController _ngoCreatePostScreenController;

  NgoCreatePostScreen({super.key, required this.isNgo, this.nameAndPhoto}) {
    // register controller immediately (before any build/field lookups)
    _ngoCreatePostScreenController = Get.put(
      NgoCreatePostScreenController(isNgo: isNgo),
    );
  }

  final String? organizationId = Get.arguments as String?;

  @override
  Widget build(BuildContext context) {

    final String? orgName = nameAndPhoto?['name'];
    final String? orgPhoto = nameAndPhoto?['photo'];
    final c = _ngoCreatePostScreenController;
    if (kDebugMode) {
      print('here is received orgId: $organizationId');
    }
    c.orgId.value = organizationId ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScreenHeaderRow(
                title: "Create Post",
                hasLastButton: true,
                buttonTitle: "Post",
                buttonAction: () {
                  c.createPost();
                },
              ),
            ),
            const SizedBox(height: 24),
            //profile image, name and profileType
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NGOCreatePostProfileRowWidget(isNgo: isNgo,name: orgName,photo: orgPhoto,),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: c.postTEController,
                  maxLines: 5,
                  onChanged: (value) {
                    c.postText.value = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),

            const Spacer(flex: 2),

            // preview if media exists
            Obx(() {
              final picked = c.pickedFile.value;
              final mediaType = c.mediaType.value;
              if (picked != null) {
                if (mediaType == MediaType.image) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        picked,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else if (mediaType == MediaType.video) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_circle_fill, size: 36),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                picked.path.split('/').last,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: c.removeMedia,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            }),

            //bottom category container
            Obx(() {
              final text = c.postText.value.trim();
              if (text.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey.shade300),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 3,
                          indent: 150,
                          endIndent: 150,
                        ),
                        bottomCatagoryRow(
                          categoryName: "Photo/Video",
                          imagePath: IconsPath.photoIcon,
                          bgColor: const Color(0XFFDCFCE7),
                          categoryAction: () {
                            c.pickImage();
                          },
                        ),
                        const SizedBox(height: 5),
                        bottomCatagoryRow(
                          categoryName: "Tag Category",
                          imagePath: IconsPath.gridIcon,
                          bgColor: const Color(0XFFDBEAFE),
                          categoryAction: () {},
                        ),
                        const SizedBox(height: 5),
                        bottomCatagoryRow(
                          categoryName: "Feeling/Activity",
                          imagePath: IconsPath.feelingIcon,
                          bgColor: const Color(0XFFFEE2E2),
                          categoryAction: () {},
                        ),
                        const SizedBox(height: 5),
                        bottomCatagoryRow(
                          categoryName: "Check In",
                          imagePath: IconsPath.checkInIcon,
                          bgColor: const Color(0XFFF3E8FF),
                          categoryAction: () {},
                        ),
                        const SizedBox(height: 5),
                        bottomCatagoryRow(
                          categoryName: "Accept Volunteer",
                          imagePath: IconsPath.groupIcon,
                          bgColor: const Color(0XFFE3FFDD),
                          categoryAction: () {},
                          isSwitchButton: true,
                          switchValue: c.isVolunteerSelected.value,
                          switchButtonAction: (value) {
                            c.isVolunteerSelected.value = value;
                          },
                        ),
                        const SizedBox(height: 5),
                        bottomCatagoryRow(
                          categoryName: "Accept Donation",
                          imagePath: IconsPath.donationBlueIcon,
                          bgColor: const Color(0XFFEDF0FF),
                          categoryAction: () {},
                          isSwitchButton: true,
                          switchValue: c.isDonationSelected.value,
                          switchButtonAction: (value) {
                            c.isDonationSelected.value = value;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      BottomRowCategoryButton(
                        onTapAction: () {
                          c.pickImage();
                        },
                        bgColor: const Color(0XFFDCFCE7),
                        imagePath: IconsPath.photoIcon,
                      ),
                      BottomRowCategoryButton(
                        onTapAction: () {},
                        bgColor: const Color(0XFFDBEAFE),
                        imagePath: IconsPath.gridIcon,
                      ),
                      BottomRowCategoryButton(
                        onTapAction: () {},
                        bgColor: const Color(0XFFFEE2E2),
                        imagePath: IconsPath.feelingIcon,
                      ),
                      BottomRowCategoryButton(
                        onTapAction: () {},
                        bgColor: const Color(0XFFF3E8FF),
                        imagePath: IconsPath.checkInIcon,
                      ),
                      BottomRowCategoryButton(
                        onTapAction: () {},
                        bgColor: const Color(0XFFE3FFDD),
                        imagePath: IconsPath.groupIcon,
                      ),
                      BottomRowCategoryButton(
                        onTapAction: () {},
                        bgColor: const Color(0XFFEDF0FF),
                        imagePath: IconsPath.donationBlueIcon,
                      ),
                    ],
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

/// Keep BottomRowCategoryButton locally to avoid missing import issues.
class BottomRowCategoryButton extends StatelessWidget {
  final VoidCallback onTapAction;
  final Color bgColor;
  final String imagePath;
  const BottomRowCategoryButton({
    super.key,
    required this.onTapAction,
    required this.bgColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapAction,
      child: CircleAvatar(
        backgroundColor: bgColor,
        child: SvgPicture.asset(imagePath),
      ),
    );
  }
}

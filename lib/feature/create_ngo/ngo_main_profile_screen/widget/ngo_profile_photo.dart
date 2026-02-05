import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';
import 'package:jdadzok/core/const/app_colors.dart';

class NgoProfilePhoto extends StatelessWidget {
  final bool showButton;
  const NgoProfilePhoto({super.key, this.showButton = true});

  @override
  Widget build(BuildContext context) {
    final NgoMainProfileScreenController controller = Get.find();
    final avatarFile = controller.avatarFile.value;
    final avatarUrl = controller.avatarUrl;

    ImageProvider imageProvider;
    if (avatarFile != null) {
      imageProvider = FileImage(avatarFile);
    } else if (avatarUrl != null && avatarUrl.isNotEmpty) {
      imageProvider = NetworkImage(avatarUrl);
    } else {
      imageProvider = AssetImage(ImagePath.ngoHexaMediaImage);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 115),
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(radius: 50, backgroundImage: imageProvider),
            ),
            if (showButton) NGOProfileBlueButton(isAddStory: true),
          ],
        ),
      ],
    );
  }
}

class NGOProfileBlueButton extends StatelessWidget {
  final bool? isAddStory;
  const NGOProfileBlueButton({super.key, this.isAddStory});

  @override
  Widget build(BuildContext context) {
    final NgoMainProfileScreenController controller = Get.find();
    return Positioned(
      bottom: 4,
      right: 5,
      child: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        radius: 15,
        child: FittedBox(
          fit: BoxFit.fill,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.photo,
                            color: Color(0xff2D55FF),
                          ),
                          title: const Text(
                            'Add profile picture',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            controller.pickImage(forCover: false);
                          },
                        ),
                        if (isAddStory == true) ...[
                          ListTile(
                            leading: const Icon(
                              Icons.history,
                              color: Color(0xff2D55FF),
                            ),
                            title: const Text(
                              'Add Story',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              controller.pickImage(forCover: false);
                            },
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

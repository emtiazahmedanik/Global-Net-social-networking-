// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/feature/create_ngo/ngo_create_post_screen/screen/ngo_create_post_screen.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:jdadzok/feature/create_ngo/ngo_profile_donation_screen/screen/ngo_profile_donation_screen.dart';
import 'package:jdadzok/route/app_route.dart';

class NgoProfileButtonRow extends StatelessWidget {
  final bool isNgo;
  const NgoProfileButtonRow({super.key, required this.isNgo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NgoMainProfileScreenController>();
    return Row(
      children: [
        Expanded(
          child: ngoProfileButton(
            targetWidget: Text(isNgo ? "NGO Post" : "Post Community"),
            onPressedAction: () {
              final org = controller.org.value;
              final orgId = org?.id;
              final name =
                  org?.profile?.name ??
                  org?.profile?.username ??
                  'this organization';
              final photo = org?.profile?.avatarUrl;
              Get.to(
                () => NgoCreatePostScreen(
                  isNgo: isNgo,
                  nameAndPhoto: {'name': name, 'photo': photo},
                ),
                arguments: orgId,
              );
            },
            bgColor: AppColors.primaryColor,
            fgColor: Colors.white,
          ),
        ),
        ngoProfileButton(
          targetWidget: Icon(
            Icons.visibility_outlined,
            color: Colors.grey.shade800,
          ),
          onPressedAction: () {
            Get.to(() => NgoProfileDonationScreen(isNgo: isNgo));
          },
        ),
        ngoProfileButton(
          targetWidget: SvgPicture.asset(IconsPath.editIcon),
          onPressedAction: () {
            final org = controller.org.value;
            if (org != null) {
              Get.toNamed(
                AppRoute.editCommunityNGO,
                arguments: {'isNgo': isNgo, 'org': org},
              );
            }
          },
        ),
        ngoProfileButton(
          targetWidget: Icon(Icons.share),
          onPressedAction: () async {
            final org = controller.org.value;
            final name =
                org?.profile?.name ??
                org?.profile?.username ??
                'this organization';
            try {
              await Share.share('Check out $name on Jdadzok!');
              EasyLoading.showSuccess('Share sheet opened');
            } catch (e) {
              if (kDebugMode) debugPrint('Share failed: $e');
              EasyLoading.showError('Unable to share');
            }
          },
        ),
      ],
    );
  }
}

Widget ngoProfileButton({
  required Widget targetWidget,
  required VoidCallback onPressedAction,
  Color? bgColor,
  Color? fgColor,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: ElevatedButton(
      onPressed: onPressedAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? Colors.grey[300],
        foregroundColor: fgColor ?? Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: targetWidget,
    ),
  );
}

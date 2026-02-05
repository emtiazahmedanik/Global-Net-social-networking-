// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_profile_button_row.dart';
import 'package:jdadzok/feature/create_ngo/ngo_profile_donation_screen/widget/ngo_donation_dialog_widget.dart';
import 'package:jdadzok/feature/explore/controller/explore_screen_controller.dart';
import 'package:jdadzok/route/app_route.dart';

class NgoDonationButtonRowWidget extends StatelessWidget {
  final bool isNgo;
  final OrganizationModel org;
  
  const NgoDonationButtonRowWidget({
    super.key,
    required this.isNgo,
    required this.org,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize ExploreScreenController if not already initialized
    final ExploreScreenController exploreController = Get.put(ExploreScreenController(), permanent: false);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (isNgo) ...[
            // NGO: Show all buttons (Donate, Apply, Add friend request, Share)
            ngoProfileButton(
              targetWidget: Row(
                children: [
                  SvgPicture.asset(IconsPath.donationIcon),
                  SizedBox(width: 5),
                  Text("Donate"),
                ],
              ),
              onPressedAction: () {
                // Show donation dialog
                showDialog(
                  context: context,
                  builder: (context) => NgoDonationDialogWidget(org: org),
                );
              },
              bgColor: AppColors.primaryColor,
              fgColor: AppColors.backgroundColor,
            ),
            ngoProfileButton(
              targetWidget: Row(
                children: [
                  SvgPicture.asset(IconsPath.ngoApplyIcon),
                  SizedBox(width: 5),
                  Text("Apply"),
                ],
              ),
              onPressedAction: () {
                Get.toNamed(
                  AppRoute.applyVerificationScreen,
                  arguments: {'isNgo': isNgo, 'org': org},
                );
              },
              bgColor: AppColors.primaryColor,
              fgColor: AppColors.backgroundColor,
            ),
            // NGO: Show Follow button (like community)
            Obx(() {
              final isFollowing = exploreController.followStatus[org.id] == true;
              final isLoading = exploreController.loadingFollowingIds.contains(org.id);
              
              if (isLoading) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: 80,
                    height: 30,
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                );
              }
              
              return ngoProfileButton(
                targetWidget: Text(isFollowing ? "Following" : "Follow"),
                onPressedAction: () {
                  exploreController.toggleNgoFollow(org.id, 0);
                },
                bgColor: isFollowing ? Colors.grey[300] : AppColors.primaryColor,
                fgColor: isFollowing ? Colors.black : AppColors.backgroundColor,
              );
            }),
            ngoProfileButton(
              targetWidget: SvgPicture.asset(IconsPath.shareIcon),
              onPressedAction: () async {
                final name = org.profile?.name ?? org.profile?.username ?? 'this organization';
                try {
                  await Share.share('Check out $name on Jdadzok!');
                  EasyLoading.showSuccess('Share sheet opened');
                } catch (e) {
                  if (kDebugMode) debugPrint('Share failed: $e');
                  EasyLoading.showError('Unable to share');
                }
              },
            ),
          ] else ...[
            // Community: Show Follow button (UI like Donate button)
            Obx(() {
              final isFollowing = exploreController.followStatus[org.id] == true;
              final isLoading = exploreController.loadingFollowingIds.contains(org.id);
              
              if (isLoading) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: 80,
                    height: 30,
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                );
              }
              
              return ngoProfileButton(
                targetWidget: Text(isFollowing ? "Following" : "Follow"),
                onPressedAction: () {
                  exploreController.toggleFollow(org.id, 0);
                },
                bgColor: isFollowing ? Colors.grey[300] : AppColors.primaryColor,
                fgColor: isFollowing ? Colors.black : AppColors.backgroundColor,
              );
            }),
            // Community: Show message button (UI like Add friend request button)
            ngoProfileButton(
              targetWidget: SvgPicture.asset(IconsPath.messageIcon),
              onPressedAction: () {
                // Navigate to chat screen with community owner ID
                Get.toNamed(
                  AppRoute.individualChat,
                  arguments: org.ownerId,
                );
              },
            ),
            // Community: Show share button (UI like Add friend request button)
            ngoProfileButton(
              targetWidget: SvgPicture.asset(IconsPath.shareIcon),
              onPressedAction: () async {
                final name = org.profile?.name ?? org.profile?.username ?? 'this organization';
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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/notification/screen/notification_screen.dart';

import '../../../theme/app_colors.dart';
import '../../../core/const/image_path.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';
import '../../../core/const/icons_path.dart';
import '../../../route/app_route.dart';
import 'search_bar_widget.dart';

class HomeHeader extends StatelessWidget {
  final Function(String) onSearchChanged;
  final TextEditingController searchController;

  const HomeHeader({super.key, required this.onSearchChanged, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Title and Actions
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 10,
                  left: 16,
                  right: 16,
                  bottom: 5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Synq',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.66,
                                  ),
                                ),
                                TextSpan(
                                  text: 'ULAN',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -0.66,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => NotificationScreen());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: ShapeDecoration(
                                    color: AppColors.secondaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    IconsPath.notificationIcon,
                                    width: 18,
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 13),
                              GestureDetector(
                                onTap: () => Get.toNamed(AppRoute.getChat()),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  padding: EdgeInsets.all(7),
                                  decoration: ShapeDecoration(
                                    color: AppColors.secondaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    IconsPath.messageIcon,
                                    width: 18,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 13),

                              GestureDetector(
                                onTap: () => Get.toNamed(AppRoute.friendRequest),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  padding: EdgeInsets.all(7),
                                  decoration: ShapeDecoration(
                                    color: AppColors.secondaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    IconsPath.addFriendRequestIcon,
                                    width: 18,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // Profile and Search
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: GetBuilder<PersonalProfileViewController>(
                              init: PersonalProfileViewController(),
                              builder: (pc) {
                                final avatar = pc.profile.value?.data?.avatarUrl ?? '';
                                return Container(
                                  width: 38,
                                  height: 38,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: avatar.isNotEmpty ? NetworkImage(avatar) as ImageProvider : AssetImage(ImagePath.profileImage001),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            onTap: () {
                              Get.toNamed(AppRoute.personalProfileview);
                            },
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SearchBarWidget(onChanged: onSearchChanged, controller: searchController),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

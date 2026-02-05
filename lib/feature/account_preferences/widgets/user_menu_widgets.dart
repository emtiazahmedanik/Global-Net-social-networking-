import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/change_password/screen/change_password_screen.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_profile_screen/screen/create_ngo_comunity_profile_screen.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/screen/create_ngo_verify_profile_screen.dart';
import 'package:jdadzok/feature/edit_profile/screen/edit_profile_screen.dart';
import 'package:jdadzok/feature/withdraw/screen/withdraw_request_screen.dart';
import 'package:jdadzok/feature/payment_method/screen/add_payment_method_screen.dart';
import 'package:jdadzok/feature/account_preferences/controller/notification_controller.dart';

class UserMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const UserMenuItem({
    super.key,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: trailing == null ? onTap : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.8,
            ),
          ),
          trailing ??
              IconButton(
                iconSize: 15,
                icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                onPressed: onTap,
              ),
        ],
      ),
    );
  }
}

class UserMenuWidgets extends StatelessWidget {
  UserMenuWidgets({super.key});

  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserMenuItem(
          title: 'Edit Profile',
          onTap: () {
            Get.to(() => EditProfileScreen());
          },
        ),
        UserMenuItem(
          title: 'Change Password',
          onTap: () {
            Get.to(() => ChangePasswordScreen());
          },
        ),
        UserMenuItem(
          title: 'Payments',
          onTap: () {
            Get.to(() => AddPaymentMethodScreen());
          },
        ),
        UserMenuItem(
          title: 'Withdraw',
          onTap: () {
            Get.to(() => WithdrawRequestScreen());
          },
        ),
        UserMenuItem(
          title: 'Create Community',
          onTap: () {
            Get.to(() => CreateNgoComunityProfileScreen(isNgo: false));
          },
        ),
        UserMenuItem(
          title: 'Your Community',
          onTap: () {
            // open the verify/profile screen for Community
            Get.to(() => CreateNgoVerifyProfileScreen(isNgo: false));
          },
        ),
        UserMenuItem(
          title: 'Create NGO',
          onTap: () {
            Get.to(() => CreateNgoComunityProfileScreen(isNgo: true));
          },
        ),
        UserMenuItem(
          title: 'Your NGO',
          onTap: () {
            // open the verify/profile screen for NGO
            Get.to(() => CreateNgoVerifyProfileScreen(isNgo: true));
          },
        ),
        

        UserMenuItem(
          title: 'Push Notifications',
          trailing: Obx(
            () => Transform.scale(
              scale: 0.7, //
              child: Switch(
                value: notificationController.isNotificationOn.value,
                onChanged: notificationController.toggleNotification,
                activeThumbColor: Color(0xFFFFFFFF),
                activeTrackColor: Color(0xFF2D55FF),
                inactiveThumbColor: Color(0xFF2D55FF),
                inactiveTrackColor: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

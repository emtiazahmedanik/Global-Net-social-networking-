import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/chat/chat%20more%20option/shared%20links/screen/shared_links_screen.dart';
import 'package:jdadzok/feature/chat/chat%20more%20option/shared%20photos/screen/shared_photos_screen.dart';

class ProfileOptionsDialog {
  static void showDialogOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOption(
                  icon: Icons.photo,
                  text: "8 Photos",
                  onTap: () {
                    Get.back();
                    Get.to(SharedPhotosScreen());
                  },
                ),
                _buildOption(
                  icon: Icons.link,
                  text: "24 Link Shared",
                  onTap: () {
                    Get.back();
                    Get.to(SharedLinksScreen());
                  },
                ),
                _buildOption(
                  icon: Icons.share,
                  text: "Share Profile",
                  onTap: () {
                    Get.back();
                    Get.toNamed('/share-profile');
                  },
                ),
                const Divider(),
                _buildOption(
                  icon: Icons.block,
                  text: "Block User",
                  color: Colors.red,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/block-user');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

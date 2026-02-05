// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({
    super.key,
    required this.searchController,
    required this.onTapSearch,
    this.onChanged,
  });

  TextEditingController searchController;
  VoidCallback onTapSearch;
  ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(PersonalProfileViewController());
    return Row(
      children: [
        Obx(() {
          final avatar = profileController.profile.value?.data?.avatarUrl;
          if (avatar != null && avatar.isNotEmpty) {
            return CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatar));
          }
          return CircleAvatar(radius: 22, child: Image.asset(ImagePath.activeUserImage));
        }),

        SizedBox(width: 12),

        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                suffixIcon: GestureDetector(
                  onTap: onTapSearch,
                  child: Icon(Icons.search, color: Colors.grey)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/home/index.dart';
import '../../../theme/app_colors.dart';
import '../../../core/const/icons_path.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.hintText = 'Search', required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              homeController.onTapSearch();
            },
            child: SvgPicture.asset(
              IconsPath.searchIcon,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(AppColors.greyText, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

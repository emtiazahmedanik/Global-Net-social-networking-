import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdadzok/core/const/app_colors.dart';

class CustomBottomNavItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCenter;

  const CustomBottomNavItem({
    super.key,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: ShapeDecoration(
            color: AppColors.redColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: _buildIconWithState()),
      ),
    );
  }

  Widget _buildIconWithState() {
    return SvgPicture.asset(
      iconPath,
      width: 26,
      height: 26,
      colorFilter: ColorFilter.mode(
        isSelected
            ? AppColors
                  .primaryColor // Bold blue for selected
            : const Color(0xFFBDBDBD), // Light grey for unselected
        BlendMode.srcIn,
      ),
    );
  }
}

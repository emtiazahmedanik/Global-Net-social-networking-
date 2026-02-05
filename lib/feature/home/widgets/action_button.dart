import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String iconPath;
  final String? text;
  final int? count;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;
  final double iconSize;

  const ActionButton({
    super.key,
    required this.iconPath,
    this.text,
    this.count,
    this.iconColor,
    this.textColor,
    required this.onTap,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = iconColor ?? AppColors.greyText;
    final displayTextColor = textColor ?? AppColors.greyText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: ShapeDecoration(
          color: AppColors.lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(displayColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 4),
            Text(
              text ?? count?.toString() ?? '',
              style: TextStyle(
                color: displayTextColor,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.93,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

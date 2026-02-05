import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/const/icons_path.dart';

class PostOptionsModal extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onPhotoVideoTap;
  final VoidCallback onTagPeopleTap;
  final VoidCallback onFeelingActivityTap;
  final VoidCallback onCheckInTap;
  final VoidCallback onGifTap;

  const PostOptionsModal({
    super.key,
    required this.isCollapsed,
    required this.onPhotoVideoTap,
    required this.onTagPeopleTap,
    required this.onFeelingActivityTap,
    required this.onCheckInTap,
    required this.onGifTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      // Collapsed state - horizontal buttons
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 10,
              offset: Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildCollapsedOption(
              backgroundColor: const Color(0xFFDCFCE7),
              iconPath: IconsPath.photoIcon,
              label: 'Photo/Video',
              onTap: onPhotoVideoTap,
            ),
            const SizedBox(width: 15),
            _buildCollapsedOption(
              backgroundColor: const Color(0xFFDBEAFE),
              iconPath: IconsPath.tagPeopleIcon,
              label: 'Tag People',
              onTap: onTagPeopleTap,
            ),
            const SizedBox(width: 15),
            _buildCollapsedOption(
              backgroundColor: const Color(0xFFFEE2E2),
              iconPath: IconsPath.feelingIcon,
              label: 'Feeling/Activity',
              onTap: onFeelingActivityTap,
            ),
            // const SizedBox(width: 15),
            // _buildCollapsedOption(
            //   backgroundColor: const Color(0xFFF3E8FF),
            //   iconPath: IconsPath.checkInIcon,
            //   label: 'Check in',
            //   onTap: onCheckInTap,
            // ),
            // const SizedBox(width: 15),
            // _buildCollapsedOption(
            //   backgroundColor: const Color(0xFFFFEDD5),
            //   iconPath: IconsPath.giftIcon,
            //   label: 'GIF',
            //   onTap: onGifTap,
            // ),
          ],
        ),
      );
    }

    // Expanded state - full modal
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 20),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19858585),
            blurRadius: 5,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 15),

          // Options
          _buildFullOption(
            backgroundColor: const Color(0xFFDCFCE7),
            iconPath: IconsPath.photoIcon,
            title: 'Photo/Video',
            onTap: onPhotoVideoTap,
          ),
          const SizedBox(height: 15),
          _buildFullOption(
            backgroundColor: const Color(0xFFDBEAFE),
            iconPath: IconsPath.tagPeopleIcon,
            title: 'Tag People',
            onTap: onTagPeopleTap,
          ),
          const SizedBox(height: 15),
          _buildFullOption(
            backgroundColor: const Color(0xFFFEE2E2),
            iconPath: IconsPath.feelingIcon,
            title: 'Feeling/Activity',
            onTap: onFeelingActivityTap,
          ),
          const SizedBox(height: 15),
          // _buildFullOption(
          //   backgroundColor: const Color(0xFFF3E8FF),
          //   iconPath: IconsPath.checkInIcon,
          //   title: 'Check In',
          //   onTap: onCheckInTap,
          // ),
          // const SizedBox(height: 15),
          // _buildFullOption(
          //   backgroundColor: const Color(0xFFFFEDD5),
          //   iconPath: IconsPath.giftIcon,
          //   title: 'GIF',
          //   onTap: onGifTap,
          // ),
        ],
      ),
    );
  }

  Widget _buildCollapsedOption({
    required Color backgroundColor,
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            Color(0xFF374151),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildFullOption({
    required Color backgroundColor,
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF374151),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

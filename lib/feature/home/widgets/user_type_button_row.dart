import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/icons_path.dart';

class UserTypeButtonRow extends StatelessWidget {
  const UserTypeButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              //Join as Volunteer button action work here
              debugPrint("Join as Volunteer is selected");
            },
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.group, color: Colors.white),
                Text("Join as Volunteer"),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFFF5F5F8),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              //Donate button action here
              debugPrint("Donation button selected");
            },
            child: Row(
              spacing: 8,
              children: [
                SvgPicture.asset(IconsPath.donationBlueIcon),
                Text("Donate", style: TextStyle(color: Color(0XFF6A6A6A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

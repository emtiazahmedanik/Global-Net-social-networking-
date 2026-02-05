import 'package:flutter/material.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/core/style/global_text_style.dart';

class ExploreScreenListTile extends StatelessWidget {
  const ExploreScreenListTile({
    super.key,
    required this.image,
    required this.name,
    required this.mutualFriend,
    required this.addFriendAction,
    this.varifiedText,
    this.isVerified,
    this.capIcon,
  });

  final String image;
  final String name;
  final String? mutualFriend;
  final VoidCallback addFriendAction;
  final String? varifiedText;
  final bool? isVerified;
  final bool? capIcon;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      separatorBuilder: (context, index) {
        return SizedBox(height: 4);
      },
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0.5,
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              radius: 22,
              child: Image.asset(image), //ImagePath.exploreScreenCircleImage
            ),
            title: Row(
              children: [
                Text(
                  name,
                  //"Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                //
                if (isVerified == true) ...[
                  SizedBox(width: 6),
                  Icon(
                    Icons.verified_rounded,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                ],

                if (varifiedText != null) ...[
                  SizedBox(width: 2),
                  Text("Verified", style: _textStyle()),
                ],
                SizedBox(width: 5),
                if (capIcon != null) ...[
                  Row(
                    children: [
                      Image.asset(IconsPath.capIcon, width: 16, height: 16),
                      SizedBox(width: 2),
                      Text("New", style: _textStyle()),
                    ],
                  ),
                ],
              ],
            ),
            subtitle: mutualFriend != null
                ? Text(
                    mutualFriend!,
                    style: globalTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF6A6A6A),
                    ),
                  )
                : null,
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                side: BorderSide(width: 0.5, color: AppColors.primaryColor),
                minimumSize: Size(63, 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: addFriendAction,
              child: Text("Follow"),
            ),
          ),
        );
      },
    );
  }
}

TextStyle _textStyle() {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
  );
}

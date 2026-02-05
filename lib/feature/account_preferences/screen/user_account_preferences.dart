import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_view_button.dart';
import 'package:jdadzok/feature/personal_view/screen/profile_personal_view.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/followers_widget.dart';
import 'package:jdadzok/feature/account_preferences/widgets/more_options_widgets.dart';
import 'package:jdadzok/feature/account_preferences/widgets/user_details.dart';
import 'package:jdadzok/feature/account_preferences/widgets/user_menu_widgets.dart';

class UserAccountPreferences extends StatelessWidget {
  const UserAccountPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Account Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff111827),
                    ),
                  ),
                ),
                SizedBox(height: 29),
                UserDetails(),
                SizedBox(height: 12),
                Followers(),
                SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomViewButton(
                      width: MediaQuery.of(context).size.width * 0.41,
                      text: 'View Analytics',
                      color: Color(0XFF2D55FF),

                      onPressed: () {
                        Get.toNamed('AnalyticsScreen');
                      },
                      textColor: Color(0XFFFFFFFF),
                    ),

                    CustomViewButton(
                      width: MediaQuery.of(context).size.width * 0.41,
                      text: 'View Profile',
                      textColor: Color(0XFF6A6A6A),

                      color: Color(0XFFEFEFEF),

                      onPressed: () {
                        Get.to(() => ProfilePersonalView(),);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Color(0xffCACACA), thickness: 1, height: 0.5),
                SizedBox(height: 16),

                UserMenuWidgets(),
                SizedBox(height: 17),
                Divider(color: Color(0xffCACACA), thickness: 1, height: 0.5),
                SizedBox(height: 16),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'More',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                          color: Color(0xff717171),
                        ),
                      ),
                    ),
                  ],
                ),
                MoreOptionsWidgets(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

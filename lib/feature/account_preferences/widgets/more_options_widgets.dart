import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/feature/account_preference_more/about_us/about_us_screen.dart';
import 'package:jdadzok/feature/account_preference_more/privacy_policy/pricacy_policy_screen.dart';
import 'package:jdadzok/feature/account_preference_more/terms_condition/terms_condition_screen.dart';
import 'package:jdadzok/feature/account_preferences/widgets/user_menu_widgets.dart';
import 'package:jdadzok/route/app_route.dart';

class MoreOptionsWidgets extends StatelessWidget {
  const MoreOptionsWidgets({super.key});

  Future<void> _handleLogout() async {
    try {
      Get.offAllNamed(AppRoute.login);

      final response = await HttpNetworkClient().postRequest(
        url: Urls.logout,
        body: {},
      );
      final body = response.responseData;
      if (body?['success'] == true) {
        EasyLoading.showSuccess('Logout successful');
        await SharedPreferencesHelper.clearAllData();
        //Get.offAllNamed(AppRoute.login);
      } else {
        EasyLoading.showError('Logout failed');
      }
    } catch (e) {
      debugPrint('logout erro : $e');
    }

    //   EasyLoading.show(status: 'Logging out...');

    //   final token = await SharedPreferencesHelper.getAccessToken();
    //   if (token == null || token.isEmpty) {
    //     await SharedPreferencesHelper.clearAllData();
    //     EasyLoading.dismiss();
    //     EasyLoading.showSuccess('Logged out successfully');
    //     Get.offAllNamed('/login_signup');
    //     return;
    //   }

    //   final response = await DioClient().client.post(Urls.logout);

    //   if (response.statusCode == 200) {
    //     await SharedPreferencesHelper.clearAllData();

    //     EasyLoading.dismiss();
    //     EasyLoading.showSuccess('Logged out successfully');

    //     Get.offAllNamed('/login_signup');
    //   } else {
    //     EasyLoading.dismiss();
    //     EasyLoading.showError('Logout failed. Please try again.');
    //   }
    // } catch (e) {
    //   EasyLoading.dismiss();

    //   // if (e is DioException) {
    //   //   if (e.response?.statusCode == 500) {
    //   //     await SharedPreferencesHelper.clearAllData();
    //   //     EasyLoading.showSuccess('Logged out successfully');
    //   //     Get.offAllNamed('/login_signup');
    //   //   } else if (e.response?.statusCode == 401) {
    //   //     await SharedPreferencesHelper.clearAllData();
    //   //     EasyLoading.showSuccess('Logged out successfully');
    //   //     Get.offAllNamed('/login_signup');
    //   //   } else {
    //   //     EasyLoading.showError('Logout failed. Please try again.');
    //   //   }
    //   // } else {
    //   //   EasyLoading.showError('Network error. Please try again.');
    //   // }

    //   debugPrint('Logout error: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BasicUserMenu(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          onTap: () => _handleLogout(),
        ),
      ],
    );
  }
}

// Renamed this to BasicUserMenu to avoid conflict
class BasicUserMenu extends StatelessWidget {
  const BasicUserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserMenuItem(
          title: 'About Us',
          onTap: () {
            Get.to(() => AboutUsScreen());
          },
        ),
        UserMenuItem(
          title: 'Privacy Policy',
          onTap: () {
            Get.to(() => PrivacyPolicyScreen());
          },
        ),
        UserMenuItem(
          title: 'Terms and Conditions',
          onTap: () {
            Get.to(() => TermsConditionScreen());
          },
        ),
      ],
    );
  }
}

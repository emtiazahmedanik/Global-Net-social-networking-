import 'package:get/get.dart';
import 'package:jdadzok/feature/auth/login_signup/screen/login_signup_screen.dart';
import 'package:jdadzok/feature/auth/reset_password/screen/reset_password_screen.dart';
import 'package:jdadzok/feature/auth/verification_page/screen/verification_page_screen.dart';
import 'package:jdadzok/feature/auth/verify_code/screen/verify_code_screen.dart';
import 'package:jdadzok/feature/auth/verify_reset_password/screen/verify_reset_password_screen.dart';
import 'package:jdadzok/feature/change_password/screen/change_password_screen.dart';
import 'package:jdadzok/feature/chat/screen/individual_chat_screen.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/screen/apply_verification_details_screen.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification/screen/apply_verification_screen.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_profile_screen/screen/create_ngo_comunity_profile_screen.dart';
import 'package:jdadzok/feature/create_ngo/edit_ngo_profile_screen/screen/edit_ngo_comunity_profile_screen.dart';
import 'package:jdadzok/feature/create_ngo/identity%20verification/screen/identity_verification_screen.dart';
import 'package:jdadzok/feature/create_ngo/upload%20documents/screen/upload_document_screen.dart';
import 'package:jdadzok/feature/edit_profile/screen/edit_profile_screen.dart';
import 'package:jdadzok/feature/explore/screen/explore_screen.dart';
import 'package:jdadzok/feature/friend_request/screen/friend_request_screen.dart';
import 'package:jdadzok/feature/notification/screen/notification_screen.dart';
import 'package:jdadzok/feature/payment_method/screen/add_payment_method_screen.dart';
import 'package:jdadzok/feature/inapp_payment/screen/inapp_payment_screen.dart';
import 'package:jdadzok/feature/analytics/screen/analytics_screen.dart';
import 'package:jdadzok/feature/personal_view/screen/profile_personal_view.dart';
import 'package:jdadzok/feature/public_view/screen/public_profile_view.dart';
import '../feature/choice/screen/choice_screen.dart';
import '../feature/splash/screen/splash_screen.dart';
import '../feature/welcome/screen/welcome_screen.dart';
import '../feature/bottom_navbar/screen/bottom_navbar_screen.dart';
import '../feature/home/screen/home_page.dart';

import '../feature/account_preferences/screen/user_account_preferences.dart';

import '../feature/marketplace/screen/marketplace_screen.dart';

import '../feature/create_post/screen/create_post_page.dart';
import '../feature/chat/screen/chat_screen.dart';
import '../feature/real_time_calling/screen/video_call_screen.dart';

// add these imports at top of the file where you define appPages/GetPage
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

/// ============================================================================
/// NAVIGATION EXAMPLES
/// ============================================================================
///
/// ApplyVerificationDetailsScreen Navigation:
///
/// // Option 1: Auto-fetch from API (No arguments)
/// Get.toNamed(AppRoute.applyVerificationDetailsScreen);
///
/// // Option 2: Auto-fetch with isNgo flag
/// Get.toNamed(
///   AppRoute.applyVerificationDetailsScreen,
///   arguments: {'isNgo': true},  // or false for Community
/// );
///
/// // Option 3: Pass organization model (no API call)
/// Get.toNamed(
///   AppRoute.applyVerificationDetailsScreen,
///   arguments: {
///     'isNgo': true,
///     'org': organizationModel,
///   },
/// );
///
/// ============================================================================

class AppRoute {
  static String splashScreen = '/splashScreen';

  static String welcomeScreen = '/welcome';
  static String login = '/login_signup';
  static String signup = '/signup';
  static String verify = '/verify_code';
  static String verifyResetPassword = '/verify_reset_password';
  static String forgotPassword = '/forgot-password';
  static const resetPassword = '/reset_password';
  static String choice = '/choice';

  static String bottomNavbar = '/bottomNavbar';
  static String notification = "/notification";
  static String friendRequest = "/friendRequest";

  static String changePasswordScreen = "/changePasswordScreen";

  // Bottom Navbar Tab Routes
  static String home = '/home';
  static String explorer = '/explorer';
  static String marketplace = '/marketplace';
  static String profile = '/profile';

  // Action Routes
  static String createPost = '/createPost';

  static String editCommunityNGO = '/editCommunityNGO';

  static String chat = '/chat';
  static String individualChat = '/individualChat';

  static String profilePublicView = '/ProfilePublicView';

  static String addPaymentMethodScreen = '/addPaymentMethodScreen';
  static String inAppPaymentScreen = '/inAppPaymentScreen';

  static String getInAppPaymentScreen() => inAppPaymentScreen;

  static String editProfileScreen = '/editProfileScreen';
  static String analyticsScreen = '/AnalyticsScreen';
  static String personalProfileview = '/profilepersonalview';
  static String createNGOVerifyScreen = '/createNGOVerifyScreen';
  static String createNGOMainProfileScreen = '/createNGOMainProfileScreen';
  static String createNGOProfileDonationScreen =
      '/createNGOProfileDonationScreen';
  static String ngoCreatePostScreen = '/ngoCreatePostScreen';
  static String applyVerificationScreen = '/applyverificationScreen';
  static String applyVerificationDetailsScreen =
      '/applyverificationDetailsScreen';
  static String identityVerificationScreen = '/identityVerificationScreen';
  static String uploadDocumentScreen = '/UploadDocumentScreen';
  static String videoCallScreen = '/VideoCallScreen';

  static String getSplashScreen() => splashScreen;

  static String getBottomNavbar() => bottomNavbar;

  static String getHome() => home;

  static String getEditCommunityNGO() => editCommunityNGO;

  static String getExplorer() => explorer;

  static String getMarketplace() => marketplace;

  static String getProfile() => profile;

  static String getCreatePost() => createPost;
  static String getNotification() => notification;

  static String getProfilePublicView() => profilePublicView;

  static String getChangePasswordScreen() => changePasswordScreen;

  static String getChat() => chat;

  static String getIndividualChat() => individualChat;

  static String getAddPaymentMethodScreen() => addPaymentMethodScreen;

  static String getEditProfileScreen() => editProfileScreen;
  static String getPersonalprofileview() => personalProfileview;
  static String getCreateNGOVerifyScreen() => createNGOVerifyScreen;
  static String getCreateNGOMainProfileScreen() => createNGOMainProfileScreen;
  static String getCreateNGOProfileDonationScreen() =>
      createNGOProfileDonationScreen;
  static String getNgoCreatePostScreen() => ngoCreatePostScreen;
  static String getApplyVerificationScreen() => applyVerificationScreen;
  static String getApplyVerificationDetailsScreen() =>
      applyVerificationDetailsScreen;
  static String getIdentityVerificationScreen() => identityVerificationScreen;
  static String getUpleadDocumentScreen() => uploadDocumentScreen;
  static String getVideoCallScreen() => videoCallScreen;
  static const String editOrganization = '/edit-organization';

  static List<GetPage> routes = [
    GetPage(name: welcomeScreen, page: () => WelcomeScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: verify, page: () => VerifyCodeScreen()),
    GetPage(name: verifyResetPassword, page: () => VerifyResetPasswordScreen()),
    GetPage(name: forgotPassword, page: () => VerificationPageScreen()),
    GetPage(name: resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: choice, page: () => ChoiceScreen()),

    GetPage(name: analyticsScreen, page: () => AnalyticsScreen()),

    GetPage(
      name: editCommunityNGO,
      page: () => EditNgoCommunityProfileScreen(),
    ),

    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: bottomNavbar,
      page: () => BottomNavbarScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => HomePage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: explorer,
      page: () => ExploreScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: marketplace,
      page: () => MarketplaceScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: profile,
      page: () => UserAccountPreferences(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: createPost,
      page: () => CreatePostPage(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 400),
    ),

    GetPage(
      name: chat,
      page: () => ChatScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: individualChat,
      page: () => IndividualChatScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    GetPage(
      name: notification,
      page: () => NotificationScreen(),
      transition: Transition.upToDown,
    ),

    GetPage(
      name: profilePublicView,
      page: () {
        final userId = Get.parameters['userId'] ?? '';
        return PublicProfileView(userId: userId);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 250),
    ),

    GetPage(
      name: changePasswordScreen,
      page: () => ChangePasswordScreen(),
      transition: Transition.upToDown,
    ),

    GetPage(
      name: addPaymentMethodScreen,
      page: () => AddPaymentMethodScreen(),
      transition: Transition.upToDown,
    ),

    GetPage(
      name: inAppPaymentScreen,
      page: () => InAppPaymentScreen(),
      transition: Transition.upToDown,
    ),

    GetPage(
      name: editProfileScreen,
      page: () => EditProfileScreen(),
      transition: Transition.upToDown,
    ),
    GetPage(name: personalProfileview, page: () => ProfilePersonalView()),
    GetPage(
      name: applyVerificationScreen,
      page: () => ApplyVerificationScreen(),
    ),
    GetPage(
      name: applyVerificationDetailsScreen,
      page: () => ApplyVerificationDetailsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: identityVerificationScreen,
      page: () => IdentityVerificationScreen(),
    ),
    GetPage(name: uploadDocumentScreen, page: () => UploadDocumentScreen()),
    GetPage(name: friendRequest, page: () => FriendRequestScreen()),
    GetPage(
      name: videoCallScreen,
      page: () => VideoCallScreen(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: AppRoute.editOrganization,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;

        final bool isNgo = args?['isNgo'] as bool? ?? false;

        // IMPORTANT: cast to OrganizationModel? so type matches the constructor param
        final OrganizationModel? org = args?['org'] as OrganizationModel?;

        return CreateNgoComunityProfileScreen(
          isNgo: isNgo,
          existingOrg: org, // now type-safe — no more error
        );
      },
      // optional: binding, transition, etc.
    ),

    GetPage(
      name: AppRoute.applyVerificationDetailsScreen, // create this constant
      page: () => ApplyVerificationDetailsScreen(),
    ),
  ];
}

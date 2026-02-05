import 'package:get/get.dart';
import 'package:jdadzok/route/app_route.dart';

class BottomNavbarController extends GetxController {
  // Observable variable to track current selected index
  final RxInt selectedIndex = 0.obs;

  // Method to change tab
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  // Method to navigate to individual pages directly (for deep linking)
  void navigateToTab(String routeName) {
    switch (routeName) {
      case '/home':
        selectedIndex.value = 0;
        break;
      case '/explorer':
        selectedIndex.value = 1;
        break;
      case '/marketplace':
        selectedIndex.value = 3;
        break;
      case '/profile':
        selectedIndex.value = 4;
        break;
      default:
        selectedIndex.value = 0;
    }
  }

  // Method to get current route name based on index
  String getCurrentRouteName() {
    switch (selectedIndex.value) {
      case 0:
        return AppRoute.home;
      case 1:
        return AppRoute.explorer;
      case 3:
        return AppRoute.marketplace;
      case 4:
        return AppRoute.profile;
      default:
        return AppRoute.home;
    }
  }

  // Navigation helper methods
  void goToHome() => changeTab(0);
  void goToExplorer() => changeTab(1);
  void goToMarketplace() => changeTab(3);
  void goToProfile() => changeTab(4);
  void goToCreatePost() => Get.toNamed(AppRoute.createPost);
}

import 'package:get/get.dart';
import '../../../core/const/image_path.dart';
import '../../../route/app_route.dart';

class WelcomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<String> sliderImages = [
    ImagePath.welcomeIllustration,
    ImagePath.welcomeIllustration, // You can add more images later
    ImagePath.welcomeIllustration,
  ];

  void onPageChanged(int index, _) {
    currentIndex.value = index;
  }

  void onGetStarted() {
    Get.offAllNamed(AppRoute.login);
  }
}

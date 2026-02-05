import 'package:get/get.dart';

class RewardsController extends GetxController {
  var selectedDuration = '7d'.obs;
  var percentage = '30.0%'.obs;
  var isTrendingUp = true.obs;
  var rewardAmount = 12.50.obs;

  void updateDuration(String duration) {
    selectedDuration.value = duration;

    switch (duration) {
      case '7d':
        isTrendingUp.value = false;
        percentage.value = '1.2%';
        rewardAmount.value -= 0.15;
        break;
      case '15d':
        isTrendingUp.value = true;
        percentage.value = '25.0%';
        rewardAmount.value += 3.10;
        break;
      case '30d':
        isTrendingUp.value = false;
        percentage.value = '5.5%';
        rewardAmount.value -= 0.80;
        break;
      case '60d':
        isTrendingUp.value = true;
        percentage.value = '28.0%';
        rewardAmount.value += 4.20;
        break;
      case '90d':
        isTrendingUp.value = true;
        percentage.value = '30.0%';
        rewardAmount.value += 5.00;
        break;
      case '1y':
        isTrendingUp.value = false;
        percentage.value = '0.8%';
        rewardAmount.value -= 0.50;
        break;
      case 'All':
        isTrendingUp.value = true;
        percentage.value = '40.0%';
        rewardAmount.value += 61.00;
        break;
      default:
        isTrendingUp.value = true;
        percentage.value = '0.0%';
    }
  }
}

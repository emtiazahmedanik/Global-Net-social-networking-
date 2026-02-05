// lib/features/choice/controller/choice_controller.dart
import 'package:get/get.dart';

class ChoiceController extends GetxController {
  final RxList<String> selectedInterests = <String>[].obs;

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }
}

import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/services_class/friend_request_service/all_friend_request_service.dart';
import 'package:jdadzok/feature/friend_request/all_friend_request/model/all_friend_request_model.dart';

class AllFriendRequestController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<AllFriendRequestModel> friends = <AllFriendRequestModel>[].obs;
  RxString searchText = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  Future<void> loadFriends() async {
    try {
      isLoading.value = true;

      final response = await AllFriendRequestService.getAllFriends();

      if (response != null && response.responseData != null) {
        friends.clear();

        final List data = response.responseData?["data"];

        for (var json in data) {
          friends.add(AllFriendRequestModel.fromJson(json));
        }
      } else {
        EasyLoading.showError("Failed to load friends");
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<AllFriendRequestModel> get filteredFriends {
    if (searchText.value.isEmpty) return friends;

    return friends
        .where(
          (f) =>
              f.name.toLowerCase().contains(searchText.value.toLowerCase()) ||
              f.email.toLowerCase().contains(searchText.value.toLowerCase()),
        )
        .toList();
  }
}

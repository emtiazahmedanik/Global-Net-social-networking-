import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/services_class/friend_request_service/friend_request_service.dart';
import 'package:jdadzok/feature/friend_request/model/friend_request_model.dart';

class FriendRequestController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<FriendRequestModel> requests = <FriendRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      isLoading.value = true;
      final response = await FriendRequestService.getPendingFriendRequests();

      if (response != null && response.responseData != null) {
        requests.clear();
        final List data = response.responseData?["data"];
        for (var json in data) {
          requests.add(FriendRequestModel.fromJson(json));
        }
      } else {
        EasyLoading.showError(response?.responseData?["error"]);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ACCEPT
  Future<void> acceptRequest(String requestId) async {
    EasyLoading.show(status: "Accepting...");

    final response = await FriendRequestService.acceptFriendRequest(
      requestId: requestId,
    );

    EasyLoading.dismiss();

    if (response != null && response.responseData?["success"] == true) {
      requests.removeWhere((e) => e.id == requestId);
      EasyLoading.showSuccess('Friend Request Accepted');
    } else {
      EasyLoading.showError('Something went wrong');
    }
  }

  /// REJECT
  Future<void> rejectRequest(String requestId) async {
    EasyLoading.show(status: "Rejecting...");

    final response = await FriendRequestService.rejectFriendRequest(
      requestId: requestId,
    );

    EasyLoading.dismiss();

    if (response != null && response.responseData?["success"] == true) {
      requests.removeWhere((e) => e.id == requestId);
    }
  }
}

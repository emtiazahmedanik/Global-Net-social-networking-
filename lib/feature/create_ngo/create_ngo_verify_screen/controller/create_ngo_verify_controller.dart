import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

class CreateNgoVerifyController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<OrganizationModel> items = <OrganizationModel>[].obs;
  final RxInt selectedIndex = 0.obs;

  Future<void> fetchMyCommunities() async {
    await _fetchList(url: Urls.myCommunity, isNgo: false);
  }

  Future<void> fetchMyNgos() async {
    await _fetchList(url: Urls.myNgo, isNgo: true);
  }

  Future<void> _fetchList({required String url, required bool isNgo}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await HttpNetworkClient().getRequest(url: url);
      final responseBody = response.responseData;

      if (responseBody != null && responseBody['success'] == true) {
        final data = responseBody['data'] as List<dynamic>? ?? [];
        final list = OrganizationModel.listFromJson(data, isNgo: isNgo);
        items.assignAll(list);
      } else {
        final message = responseBody != null && responseBody['message'] != null
            ? responseBody['message'].toString()
            : 'Failed to fetch';
        error.value = message;
        if (kDebugMode) print('Fetch failed: $responseBody');
      }
    } catch (e) {
      error.value = 'Something went wrong';
      if (kDebugMode) print('_fetchList error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// DELETE the currently selected item (items[selectedIndex])
  /// Returns true if success
  Future<bool> deleteSelected({required bool isNgo}) async {
    if (items.isEmpty) {
      EasyLoading.showError('Nothing to delete');
      return false;
    }
    final index = selectedIndex.value.clamp(0, items.length - 1);
    final OrganizationModel target = items[index];
    final String id = target.id;
    try {
      EasyLoading.show(status: 'Deleting...');
      String url;
      if (isNgo) {
        url = Urls.deleteNgo.contains('{id}')
            ? Urls.deleteNgo.replaceAll('{id}', id)
            : "${Urls.baseUrl}/ngos/$id";
      } else {
        url = Urls.deleteCommunity.contains('{id}')
            ? Urls.deleteCommunity.replaceAll('{id}', id)
            : "${Urls.baseUrl}/communities/$id";
      }
      final response = await HttpNetworkClient().deleteRequest(url: url);
      final body = response.responseData;
      if (body != null && body['success'] == true) {
        items.removeAt(index);
        selectedIndex.value = items.isEmpty
            ? 0
            : selectedIndex.value.clamp(0, items.length - 1);
        EasyLoading.dismiss();
        EasyLoading.showSuccess(body['message'] ?? 'Deleted successfully');
        return true;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body?['message'] ?? 'Delete failed');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      return false;
    }
  }

  // chooseIndex helper (if you plan to pick specific item before delete)
  void chooseIndex(int idx) {
    if (idx >= 0 && idx < items.length) selectedIndex.value = idx;
  }
}

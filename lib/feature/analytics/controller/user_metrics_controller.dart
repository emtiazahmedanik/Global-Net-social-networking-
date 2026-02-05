import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class UserMetricsController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxString capLevel = 'NONE'.obs;
  final RxDouble totalEarnings = 0.0.obs;
  final RxDouble currentMonthEarnings = 0.0.obs;
  final RxInt totalPosts = 0.obs;
  final RxInt totalLikes = 0.obs;
  final RxInt totalFollowers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserMetrics();
  }

  Future<void> fetchUserMetrics() async {
    isLoading(true);
    try {
      final response = await HttpNetworkClient().getRequest(url: Urls.userMetrics);
      isLoading(false);
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;
        capLevel.value = data?['user']?['capLevel'] ?? 'NONE';
        totalEarnings.value = ((data?['totalEarnings'] ?? 0) as num).toDouble();
        currentMonthEarnings.value = ((data?['currentMonthEarnings'] ?? 0) as num).toDouble();
        totalPosts.value = (data?['totalPosts'] ?? 0) as int;
        totalLikes.value = (data?['totalLikes'] ?? 0) as int;
        totalFollowers.value = (data?['totalFollowers'] ?? 0) as int;
      } else {
        // ignore: avoid_print
        print('Failed to load user metrics: ${response.errorMessage}');
      }
    } catch (e) {
      isLoading(false);
      // ignore: avoid_print
      print('Error fetching user metrics: $e');
    }
  }
}

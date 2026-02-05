import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/friend_request_service/friend_request_service.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/feature/marketplace/model/single_product_response.dart';
import 'package:jdadzok/route/app_route.dart';

class ProductDetailsController extends GetxController {
  var isFavorite = false.obs;
  var isLoading = false.obs;
  var isFriend = false.obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  /// Quantity
  var quantity = 1.obs;

  RxString productId = ''.obs;
  Rxn<SingleProductResponse> singleProductResponse =
      Rxn<SingleProductResponse>();
  RxBool isFriendReqSent = false.obs;

  RxDouble productPrice = 0.0.obs; // ⭐ NEW

  @override
  void onInit() {
    super.onInit();
    getUserId();
    fetchSingleProductData();

    messageController.text =
        'Hi! Is it available right now? I\'ve an offer for...';

    amountController.text = quantity.value.toString();

    amountController.addListener(() {
      if (amountController.text.isEmpty) return;

      int? value = int.tryParse(amountController.text);
      if (value == null || value < 1) {
        quantity.value = 1;
        amountController.text = "1";
      } else {
        quantity.value = value;
      }
    });
  }

  RxString userId = ''.obs;

  void getUserId() async {
    userId.value = await SharedPreferencesHelper.getUserId() ?? '';
  }

  @override
  void onClose() {
    amountController.dispose();
    messageController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void increaseQty() {
    quantity.value++;
    amountController.text = quantity.value.toString();
  }

  void decreaseQty() {
    if (quantity.value > 1) {
      quantity.value--;
      amountController.text = quantity.value.toString();
    }
  }

  /// -------------------------------------------------------
  /// ⭐ FINAL FIXED ORDER API CALL
  /// -------------------------------------------------------
  Future<void> placeOrderApiCall(String productId) async {
    if (addressController.text.isEmpty) {
      EasyLoading.showError("Please enter address");
      return;
    }

    // Validate quantity
    if (quantity.value < 1) {
      EasyLoading.showError("Quantity must be at least 1");
      return;
    }

    final available = singleProductResponse.value?.data?.availability?.toInt();
    if (available != null && available >= 0 && quantity.value > available) {
      EasyLoading.showError("Quantity exceeds available stock ($available)");
      return;
    }

    try {
      EasyLoading.show();

      double totalPrice = productPrice.value * quantity.value;

      final body = {
        "productId": productId,
        "quantity": quantity.value,
        "shippingAddress": addressController.text,
        "message": messageController.text,
        "totalPrice": totalPrice, // ⭐ MUST BE NUMBER
      };

      debugPrint("ORDER BODY: $body (availability: $available)");

      final response = await HttpNetworkClient().postRequest(
        url: Urls.placeOrder,
        body: body,
      );

      final responseBody = response.responseData;

      debugPrint("ORDER RESPONSE: $responseBody");

      if (responseBody != null && responseBody["success"] == true) {
        // Try to extract Stripe client secret from response
        final clientSecret = responseBody["data"]["data"]["clientSecret"]?.toString();
        final orderId = responseBody["data"]["data"]["order"]?["id"]?.toString();

        // Close bottom sheet
        Get.back();

        if (clientSecret != null && clientSecret.isNotEmpty) {
          // Navigate to In-App Payment screen and pass clientSecret
          EasyLoading.dismiss();
          Get.toNamed(AppRoute.getInAppPaymentScreen(), arguments: {
            'clientSecret': clientSecret,
            'orderId': orderId,
          });
        } else {
          EasyLoading.showSuccess("Order placed successfully!");
        }
      } else {
        String errorMsg = "";

        if (responseBody?["message"] is List) {
          errorMsg = (responseBody?["message"] as List).join(", ");
        } else {
          errorMsg =
              responseBody?["message"]?.toString() ??
              responseBody?["error"] ??
              "Something went wrong";
        }

        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      EasyLoading.showError("Error occurred");
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// FETCH PRODUCT
  Future<void> fetchSingleProductData() async {
    EasyLoading.show();
    try {
      final response = await HttpNetworkClient().getRequest(
        url: Urls.getSingleProductDetail(id: productId.value),
      );

      final responseBody = response.responseData;

      if (responseBody != null && responseBody['success'] == true) {
        singleProductResponse.value = SingleProductResponse.fromJson(
          responseBody,
        );

        /// ⭐ Save product price for totalPrice calculation
        productPrice.value =
            singleProductResponse.value?.data?.price?.toDouble() ?? 0.0;
      } else {
        EasyLoading.showError("Error fetching product");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> hideProductApiCall(String id) async {
    final body = {"productId": id};

    final response = await HttpNetworkClient().patchRequest(
      url: Urls.hideProduct(id),
      body: body,
    );

    final responseBody = response.responseData;

    if (responseBody != null && responseBody['success'] == true) {
      Get.back();
    } else {
      EasyLoading.showError(responseBody?['error']);
    }
  }

  Future<void> saveFavoriteProductApiCall(String id) async {
    final body = {"productId": id};

    final response = await HttpNetworkClient().postRequest(
      url: Urls.saveProductToFavorite(id),
      body: body,
    );

    final responseBody = response.responseData;

    if (responseBody != null && responseBody['success'] == true) {
      Get.back();
    } else {
      EasyLoading.showError(responseBody?['error']);
    }
  }

  Future<void> sendFriendRequest({required String id}) async {
    final HttpNetworkResponse? response =
        await FriendRequestService.sendFriendRequest(receiverId: id);

    if (response != null) {
      final responseBody = response.responseData;
      if (responseBody?['success'] == true) {
        EasyLoading.showSuccess("Friend request sent");
        isFriendReqSent.value = true;
      } else {
        EasyLoading.showError(responseBody?['error']);
      }
    }
  }

}

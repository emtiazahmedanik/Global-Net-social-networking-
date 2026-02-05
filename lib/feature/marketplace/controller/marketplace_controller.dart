import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/marketplace/model/category_response_model.dart';
import 'package:jdadzok/feature/marketplace/model/marketplace_product_model.dart';

class MarketplaceController extends GetxController {
  var selectedCategory = ''.obs;
  var searchQuery = ''.obs;

  TextEditingController searchController = TextEditingController();

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void searchProducts(String query) {
    searchQuery.value = query;
  }

  RxList<MarketplaceProduct> products = <MarketplaceProduct>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    callApies();
    super.onInit();
  }

  Future<void> callApies() async {
    await fetchAllProducts();
    await fetchProductCategory();
  }

  Future<void> fetchAllProducts({bool? isFiltered}) async {
    try {
      String url;
      if (isFiltered != null) {
        url = isFiltered
            ? Urls.getFilteredProduct(query: searchController.text.trim())
            : Urls.marketplaceProducts;
      } else {
        url = Urls.marketplaceProducts;
      }

      isLoading.value = true;
      final result = await HttpNetworkClient().getRequest(url: url);
      final response = result.responseData;
      debugPrint('ei je code : ${result.statusCode}');
      if (response != null &&
          result.statusCode == 200 &&
          response['success'] == true) {
        final productResponse = MarketplaceProductModel.fromJson(response);
        final list = productResponse.data;
        products.assignAll(list);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching products: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCategoryAllProducts({required String query}) async {
    try {
      final result = await HttpNetworkClient().getRequest(
        url: Urls.getFiltedCategoryProduct(cName: query),
      );
      final response = result.responseData;
      if (response != null &&
          result.statusCode == 200 &&
          response['success'] == true) {
        final productResponse = MarketplaceProductModel.fromJson(response);
        final list = productResponse.data;
        products.assignAll(list);
      }
    } catch (e) {
      debugPrint('query fetch error: $e');
    }
  }

  void onTapSearch() async {
    if (searchController.text.isNotEmpty) {
      await fetchAllProducts(isFiltered: true);
    }
  }

  RxList<String> categories = <String>[].obs;
  RxList<String> categoriesId = <String>[].obs;
  RxInt selectedIndex = 0.obs;
  void selectByIndex(int index) => selectedIndex.value = index;

  Future<void> fetchProductCategory() async {
    categories.clear();
    categoriesId.clear();
    final response = await HttpNetworkClient().getRequest(
      url: Urls.getProductCategory,
    );
    final responseBody = response.responseData;
    if (responseBody != null && responseBody['success'] == true) {
      debugPrint('categpries: $responseBody');
      final CategoryResponse categoryResponse = CategoryResponse.fromJson(
        responseBody,
      );
      categories.add('All');
      categories.addAll(categoryResponse.data.map((e) => e.name).toList());
      categoriesId.value = categoryResponse.data.map((e) => e.id).toList();
    }
  }


}

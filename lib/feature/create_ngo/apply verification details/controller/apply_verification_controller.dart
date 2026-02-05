import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

/// Controller for the Apply Verification details screen.
/// 
/// Handles both NGO and Community separately
class ApplyVerificationController extends GetxController {
  final Rxn<OrganizationModel> org = Rxn<OrganizationModel>();
  final RxBool isNgo = false.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // try to read passed arguments
    final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final passedIsNgo = args['isNgo'] as bool?;
      final passedOrg = args['org'] as OrganizationModel?;
      
      // Set isNgo first if provided
      if (passedIsNgo != null) isNgo.value = passedIsNgo;
      
      if (passedOrg != null) {
        // Use provided organization directly
        org.value = passedOrg;
      } else {
        // Fetch from API based on isNgo flag
        if (isNgo.value) {
          fetchMyNgos();
        } else {
          fetchMyCommunities();
        }
      }
    } else {
      // No arguments - default to Community and fetch
      isNgo.value = false;
      fetchMyCommunities();
    }
  }

  /// Fetch current user's NGOs from API
  /// API returns a list, we take the first item
  Future<void> fetchMyNgos() async {
    isNgo.value = true;
    await _fetchOrgFromAPI(url: Urls.myNgo, isNgo: true);
  }

  /// Fetch current user's Communities from API
  /// API returns a list, we take the first item
  Future<void> fetchMyCommunities() async {
    isNgo.value = false;
    await _fetchOrgFromAPI(url: Urls.myCommunity, isNgo: false);
  }

  /// Generic method to fetch from API
  Future<void> _fetchOrgFromAPI({required String url, required bool isNgo}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await HttpNetworkClient().getRequest(url: url);
      final responseBody = response.responseData;

      if (responseBody != null && responseBody['success'] == true) {
        final dataList = responseBody['data'] as List?;
        
        if (dataList != null && dataList.isNotEmpty) {
          // Parse as list and take first item
          final organizations = OrganizationModel.listFromJson(
            dataList,
            isNgo: isNgo,
          );
          org.value = organizations.first;
          
          if (kDebugMode) {
            print('Organization loaded: ${org.value?.profile?.name} (${isNgo ? 'NGO' : 'Community'})');
          }
        } else {
          error.value = isNgo ? 'No NGO found' : 'No Community found';
        }
      } else {
        error.value = responseBody?['message'] ?? (isNgo ? 'Failed to load NGO' : 'Failed to load Community');
        if (kDebugMode) {
          print('Error loading org: ${error.value}');
        }
      }
    } catch (e) {
      error.value = 'Error: $e';
      if (kDebugMode) {
        print('Fetch org error: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Convenience getters to expose smaller pieces of data
  String get name => org.value?.profile?.name ?? '';
  String get avatarUrl => org.value?.profile?.avatarUrl ?? '';
  String get coverUrl => org.value?.profile?.coverUrl ?? '';
  String get bio => org.value?.profile?.bio ?? '';
  String get location => org.value?.about?.location ?? org.value?.profile?.location ?? '';
  String get mission => org.value?.about?.mission ?? '';
  String get typeDisplay => org.value?.type ?? 'Community';
  
  /// Return "NGO" or "Community" label
  String get orgTypeLabel => isNgo.value ? 'NGO' : 'Community';
  
  String get foundingDateFormatted {
    final d = org.value?.about?.foundingDate ?? org.value?.foundationDate;
    if (d == null) return '';
    // format dd/MM/yyyy
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd/$mm/$yy';
  }

  /// Helper to indicate whether we have an org loaded
  bool get hasData => org.value != null;
}

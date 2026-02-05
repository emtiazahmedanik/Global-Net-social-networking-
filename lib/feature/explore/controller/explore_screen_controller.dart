// lib/feature/explore/controller/explore_screen_controller.dart

import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/feature/explore/model/trending_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:flutter/foundation.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';
import 'package:jdadzok/core/services_class/friend_request_service/friend_request_service.dart';

class ExploreScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchAllTrending();
    fetchTrendingCommuinty();
    fetchTrendingNgo();
    // Fetch follow statuses first, then fetch communities and NGOs
    fetchMyFollowings().then((_) {
      fetchAllCommunities(); // fetch from /communities endpoint
      fetchAllNgos(); // fetch from /ngos endpoint
    });
  }

  RxInt selectedIndex = 0.obs;
  RxString searchQuery = ''.obs;

  // --- Trending lists (restored) ---
  RxList<TrendingDataModel> trendingDataList = <TrendingDataModel>[].obs;
  RxList<TrendingDataModel> trendingCommunityList = <TrendingDataModel>[].obs;
  RxList<TrendingDataModel> trendingNgoList = <TrendingDataModel>[].obs;

  // --- Organization lists (for explore screen) ---
  RxList<OrganizationModel> allCommunitiesList = <OrganizationModel>[].obs;
  RxList<OrganizationModel> allNgosList = <OrganizationModel>[].obs;

  // --- Filtered lists for search ---
  RxList<TrendingDataModel> filteredTrendingDataList = <TrendingDataModel>[].obs;
  RxList<OrganizationModel> filteredCommunitiesList = <OrganizationModel>[].obs;
  RxList<OrganizationModel> filteredNgosList = <OrganizationModel>[].obs;

  /// Map to keep friend request status per NGO owner id (true = request sent)
  final RxMap<String, bool> friendRequestStatus = <String, bool>{}.obs;

  /// Set of owner ids currently performing friend request (to show loading)
  final RxSet<String> loadingFriendRequestIds = <String>{}.obs;

  /// Map to keep follow status per item id (true = following)
  final RxMap<String, bool> followStatus = <String, bool>{}.obs;

  /// Map to keep follow record id by followingId (optional - not necessary for POST-only toggle but kept)
  final Map<String, String> followRecordIdByFollowingId = <String, String>{};

  /// Set of ids currently performing follow/unfollow request (to show loading)
  final RxSet<String> loadingFollowingIds = <String>{}.obs;

  // ------------------ All trending (generic) ------------------
  Future<void> fetchAllTrending() async {
    try {
      EasyLoading.show();
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      Map<String, String> commonHeaders = {
        'Content-Type': 'application/json',
        'authorization': "Bearer $token",
      };
      final url = Uri.parse(Urls.allTrendings);
      final response = await http.get(url, headers: commonHeaders);
      final body = jsonDecode(response.body);
      debugPrint('trending response: $body');
      if (response.statusCode == 200 && body != null) {
        trendingDataList.clear();
        if (body is List) {
          for (var data in body) {
            TrendingDataModel dataModel = TrendingDataModel.fromJson(data);
            trendingDataList.add(dataModel);
            if (dataModel.id != null && !followStatus.containsKey(dataModel.id)) {
              followStatus[dataModel.id!] = false;
            }
          }
        }
      } else {
        EasyLoading.showError('Failed to load data');
      }
    } catch (e) {
      debugPrint('error is : $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ------------------ trending community ------------------
  Future<void> fetchTrendingCommuinty() async {
    try {
      EasyLoading.show();
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      Map<String, String> commonHeaders = {
        'Content-Type': 'application/json',
        'authorization': "Bearer $token",
      };
      final url = Uri.parse(Urls.allTrendingsCommunity);
      final response = await http.get(url, headers: commonHeaders);
      debugPrint('trending community raw response: ${response.statusCode} ${response.body}');
      final body = jsonDecode(response.body);
      debugPrint('trending community decoded: $body');
      if (response.statusCode == 200 && body != null) {
        trendingCommunityList.clear();
        final items = (body is List)
            ? body
            : (body is Map && body['data'] is List ? body['data'] as List : <dynamic>[]);
        debugPrint('trending community items count: ${items.length}');
        for (var data in items) {
          try {
            TrendingDataModel dataModel = TrendingDataModel.fromJson(data);
            trendingCommunityList.add(dataModel);
            if (dataModel.id != null && !followStatus.containsKey(dataModel.id)) {
              followStatus[dataModel.id!] = false;
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing trending community item: $e');
          }
        }
      } else {
        EasyLoading.showError('Failed to load data');
      }
    } catch (e) {
      debugPrint('error is : $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ------------------ trending ngo ------------------
  Future<void> fetchTrendingNgo() async {
    try {
      EasyLoading.show();
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      Map<String, String> commonHeaders = {
        'Content-Type': 'application/json',
        'authorization': "Bearer $token",
      };
      final url = Uri.parse(Urls.allTrendingsNgos);
      final response = await http.get(url, headers: commonHeaders);
      debugPrint('trending ngo raw response: ${response.statusCode} ${response.body}');
      final body = jsonDecode(response.body);
      debugPrint('trending ngo decoded: $body');
      if (response.statusCode == 200 && body != null) {
        trendingNgoList.clear();
        final items = (body is List) ? body : (body is Map && body['data'] is List ? body['data'] as List : <dynamic>[]);
        debugPrint('trending ngo items count: ${items.length}');
        for (var data in items) {
          try {
            TrendingDataModel dataModel = TrendingDataModel.fromJson(data);
            trendingNgoList.add(dataModel);
            if (dataModel.id != null && !followStatus.containsKey(dataModel.id)) {
              followStatus[dataModel.id!] = false;
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing trending NGO item: $e');
          }
        }
      } else {
        EasyLoading.showError('Failed to load data');
      }
    } catch (e) {
      debugPrint('error is : $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ------------------ fetch my followings ------------------
  /// GET /follows/{userId}/following
  Future<void> fetchMyFollowings() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null || userId.isEmpty) {
        if (kDebugMode) debugPrint('fetchMyFollowings: userId not found');
        return;
      }

      final url = '${Urls.follows}/$userId/following';
      final response = await HttpNetworkClient().getRequest(url: url);
      final resBody = response.responseData;

      if (response.isSuccess && resBody != null) {
        final items = (resBody is List) ? resBody : (resBody['data'] is List ? resBody['data'] : null);
        if (items != null) {
          if (kDebugMode) debugPrint('fetchMyFollowings: Found ${items.length} follow records');
          for (var rec in items) {
            try {
              final recordId = rec['id']?.toString();
              final followingId = rec['followingId']?.toString();
              // Also check for communityId or ngoId in case the API returns them differently
              final communityId = rec['communityId']?.toString();
              final ngoId = rec['ngoId']?.toString();
              
              if (recordId != null) {
                if (followingId != null) {
                  followStatus[followingId] = true;
                  followRecordIdByFollowingId[followingId] = recordId;
                  if (kDebugMode) debugPrint('Set followStatus[$followingId] = true');
                }
                // Handle communityId if present
                if (communityId != null) {
                  followStatus[communityId] = true;
                  followRecordIdByFollowingId[communityId] = recordId;
                  if (kDebugMode) debugPrint('Set followStatus[$communityId] = true (community)');
                }
                // Handle ngoId if present
                if (ngoId != null) {
                  followStatus[ngoId] = true;
                  followRecordIdByFollowingId[ngoId] = recordId;
                  if (kDebugMode) debugPrint('Set followStatus[$ngoId] = true (NGO)');
                }
              }
            } catch (e) {
              if (kDebugMode) debugPrint('parse follow record error: $e');
            }
          }
          if (kDebugMode) debugPrint('fetchMyFollowings: Total followStatus entries: ${followStatus.length}');
        }
      } else {
        if (kDebugMode) debugPrint('fetchMyFollowings failed: $resBody');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('fetchMyFollowings error: $e');
    }
  }

  // ------------------ fetch all communities from /communities endpoint ------------------
  Future<void> fetchAllCommunities() async {
    try {
      final response = await HttpNetworkClient().getRequest(url: Urls.getAllCommunities);
      final resBody = response.responseData;

      if (response.isSuccess && resBody != null && resBody['success'] == true) {
        final data = resBody['data'] as List<dynamic>? ?? [];
        allCommunitiesList.clear();
        for (var item in data) {
          try {
            final org = OrganizationModel.fromJson(item as Map<String, dynamic>, isNgo: false);
            allCommunitiesList.add(org);
            // Initialize follow status only if not already set (from fetchMyFollowings)
            // Don't overwrite existing true values
            if (org.id.isNotEmpty) {
              if (!followStatus.containsKey(org.id)) {
                followStatus[org.id] = false;
              } else {
                if (kDebugMode) debugPrint('Community ${org.id} followStatus already set to: ${followStatus[org.id]}');
              }
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing community: $e');
          }
        }
        if (kDebugMode) debugPrint('Fetched ${allCommunitiesList.length} communities');
        if (kDebugMode) debugPrint('Total followStatus entries after fetching communities: ${followStatus.length}');
      } else {
        if (kDebugMode) debugPrint('fetchAllCommunities failed: $resBody');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('fetchAllCommunities error: $e');
    }
  }

  // ------------------ fetch all NGOs from /ngos endpoint ------------------
  Future<void> fetchAllNgos() async {
    try {
      final response = await HttpNetworkClient().getRequest(url: Urls.getAllNgos);
      final resBody = response.responseData;

      if (response.isSuccess && resBody != null && resBody['success'] == true) {
        final data = resBody['data'] as List<dynamic>? ?? [];
        allNgosList.clear();
        for (var item in data) {
          try {
            final org = OrganizationModel.fromJson(item as Map<String, dynamic>, isNgo: true);
            allNgosList.add(org);
            // Initialize follow status only if not already set (from fetchMyFollowings)
            // Don't overwrite existing true values
            if (org.id.isNotEmpty) {
              if (!followStatus.containsKey(org.id)) {
                followStatus[org.id] = false;
              } else {
                if (kDebugMode) debugPrint('NGO ${org.id} followStatus already set to: ${followStatus[org.id]}');
              }
            }
            // Initialize friend request status
            if (org.ownerId.isNotEmpty && !friendRequestStatus.containsKey(org.ownerId)) {
              friendRequestStatus[org.ownerId] = false;
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing NGO: $e');
          }
        }
        if (kDebugMode) debugPrint('Fetched ${allNgosList.length} NGOs');
        if (kDebugMode) debugPrint('Total followStatus entries after fetching NGOs: ${followStatus.length}');
      } else {
        if (kDebugMode) debugPrint('fetchAllNgos failed: $resBody');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('fetchAllNgos error: $e');
    }
  }

  // ------------------ toggle community follow (community-specific endpoint) ------------------
  Future<void> toggleCommunityFollow(String communityId, int index) async {
    if (communityId.isEmpty) return;
    if (loadingFollowingIds.contains(communityId)) return;

    loadingFollowingIds.add(communityId);

    try {
      final isCurrentlyFollowing = followStatus[communityId] == true;
      HttpNetworkResponse response;
      
      if (isCurrentlyFollowing) {
        // Unfollow: DELETE request
        response = await HttpNetworkClient().deleteRequest(
          url: Urls.unfollowCommunity(communityId),
        );
      } else {
        // Follow: POST request
        response = await HttpNetworkClient().postRequest(
          url: Urls.followCommunity(communityId),
          body: {},
        );
      }

      final resBody = response.responseData;
      
      // Handle "Already following" error - update local state
      if (!response.isSuccess && resBody != null) {
        final errorMsg = (resBody['error'] ?? resBody['message'] ?? '').toString().toLowerCase();
        if (errorMsg.contains('already following') || errorMsg.contains('already follow')) {
          // Server says we're following, update local state and clean up
          final nowFollowing = true;
          followStatus[communityId] = nowFollowing;

          // Update followers count in communities list if present
          final idx = allCommunitiesList.indexWhere((e) => e.id == communityId);
          if (idx != -1) {
            final org = allCommunitiesList[idx];
            if (org.profile != null) {
              final current = org.profile!.followersCount ?? 0;
              final newProfile = ProfileModel(
                id: org.profile!.id,
                parentId: org.profile!.parentId,
                name: org.profile!.name,
                username: org.profile!.username,
                title: org.profile!.title,
                bio: org.profile!.bio,
                avatarUrl: org.profile!.avatarUrl,
                coverUrl: org.profile!.coverUrl,
                location: org.profile!.location,
                balance: org.profile!.balance,
                followersCount: current + 1,
                followingCount: org.profile!.followingCount,
                createdAt: org.profile!.createdAt,
                updatedAt: org.profile!.updatedAt,
              );
              final updatedOrg = OrganizationModel(
                id: org.id,
                ownerId: org.ownerId,
                foundationDate: org.foundationDate,
                type: org.type,
                likes: org.likes,
                isVerified: org.isVerified,
                capLevel: org.capLevel,
                isToggleNotification: org.isToggleNotification,
                createdAt: org.createdAt,
                updatedAt: org.updatedAt,
                profile: newProfile,
                about: org.about,
                isNgo: org.isNgo,
              );
              allCommunitiesList[idx] = updatedOrg;
              allCommunitiesList.refresh();
            }
          }

          // Also update followers count in the trending community list if present
          final tIdx = trendingCommunityList.indexWhere((e) => e.id == communityId);
          if (tIdx != -1) {
            final item = trendingCommunityList[tIdx];
            final current = item.followersCount ?? 0;
            item.followersCount = current + 1;
            trendingCommunityList[tIdx] = item;
            trendingCommunityList.refresh();
          }

          // Remove loading state and show success
          loadingFollowingIds.remove(communityId);
          if (kDebugMode) debugPrint('Already following community, updated local state and counts');
          EasyLoading.showSuccess('Already following');
          return;
        }
      }
      
      if (response.isSuccess && resBody != null && resBody['success'] == true) {
        // Toggle the status
        final nowFollowing = !isCurrentlyFollowing;
        followStatus[communityId] = nowFollowing;

        // Update followers count in communities list
        final idx = allCommunitiesList.indexWhere((e) => e.id == communityId);
        if (idx != -1) {
          final org = allCommunitiesList[idx];
          if (org.profile != null) {
            final current = org.profile!.followersCount ?? 0;
            final newProfile = ProfileModel(
              id: org.profile!.id,
              parentId: org.profile!.parentId,
              name: org.profile!.name,
              username: org.profile!.username,
              title: org.profile!.title,
              bio: org.profile!.bio,
              avatarUrl: org.profile!.avatarUrl,
              coverUrl: org.profile!.coverUrl,
              location: org.profile!.location,
              balance: org.profile!.balance,
              followersCount: nowFollowing ? current + 1 : (current > 0 ? current - 1 : 0),
              followingCount: org.profile!.followingCount,
              createdAt: org.profile!.createdAt,
              updatedAt: org.profile!.updatedAt,
            );
            final updatedOrg = OrganizationModel(
              id: org.id,
              ownerId: org.ownerId,
              foundationDate: org.foundationDate,
              type: org.type,
              likes: org.likes,
              isVerified: org.isVerified,
              capLevel: org.capLevel,
              isToggleNotification: org.isToggleNotification,
              createdAt: org.createdAt,
              updatedAt: org.updatedAt,
              profile: newProfile,
              about: org.about,
              isNgo: org.isNgo,
            );
            allCommunitiesList[idx] = updatedOrg;
            allCommunitiesList.refresh();
          }
        }

        // Also update followers count in the trending community list if present
        final tIdx = trendingCommunityList.indexWhere((e) => e.id == communityId);
        if (tIdx != -1) {
          final item = trendingCommunityList[tIdx];
          final current = item.followersCount ?? 0;
          item.followersCount = nowFollowing ? current + 1 : (current > 0 ? current - 1 : 0);
          trendingCommunityList[tIdx] = item;
          trendingCommunityList.refresh();
        }

        EasyLoading.showSuccess(resBody['message'] ?? (nowFollowing ? 'Followed' : 'Unfollowed'));
      } else {
        final msg = resBody != null && resBody['message'] != null ? resBody['message'].toString() : 'Follow request failed';
        if (kDebugMode) debugPrint('toggleCommunityFollow failed: $msg | response: $resBody');
        EasyLoading.showError(msg);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('toggleCommunityFollow error: $e');
      EasyLoading.showError('Something went wrong');
    } finally {
      loadingFollowingIds.remove(communityId);
    }
  }

  // ------------------ toggle NGO follow (NGO-specific endpoint) ------------------
  Future<void> toggleNgoFollow(String ngoId, int index) async {
    if (ngoId.isEmpty) return;
    if (loadingFollowingIds.contains(ngoId)) return;

    loadingFollowingIds.add(ngoId);

    try {
      final isCurrentlyFollowing = followStatus[ngoId] == true;
      HttpNetworkResponse response;
      
      if (isCurrentlyFollowing) {
        // Unfollow: DELETE request
        response = await HttpNetworkClient().deleteRequest(
          url: Urls.unfollowNgo(ngoId),
        );
      } else {
        // Follow: POST request
        response = await HttpNetworkClient().postRequest(
          url: Urls.followNgo(ngoId),
          body: {},
        );
      }

      final resBody = response.responseData;
      
      // Handle "Already following" error - update local state
      if (!response.isSuccess && resBody != null) {
        final errorMsg = (resBody['error'] ?? resBody['message'] ?? '').toString().toLowerCase();
        if (errorMsg.contains('already following') || errorMsg.contains('already follow')) {
          // Server says we're following, update local state and clean up
          final nowFollowing = true;
          followStatus[ngoId] = nowFollowing;

          // Update followers count in NGOs list if present
          final idx = allNgosList.indexWhere((e) => e.id == ngoId);
          if (idx != -1) {
            final org = allNgosList[idx];
            if (org.profile != null) {
              final current = org.profile!.followersCount ?? 0;
              final newProfile = ProfileModel(
                id: org.profile!.id,
                parentId: org.profile!.parentId,
                name: org.profile!.name,
                username: org.profile!.username,
                title: org.profile!.title,
                bio: org.profile!.bio,
                avatarUrl: org.profile!.avatarUrl,
                coverUrl: org.profile!.coverUrl,
                location: org.profile!.location,
                balance: org.profile!.balance,
                followersCount: current + 1,
                followingCount: org.profile!.followingCount,
                createdAt: org.profile!.createdAt,
                updatedAt: org.profile!.updatedAt,
              );
              final updatedOrg = OrganizationModel(
                id: org.id,
                ownerId: org.ownerId,
                foundationDate: org.foundationDate,
                type: org.type,
                likes: org.likes,
                isVerified: org.isVerified,
                capLevel: org.capLevel,
                isToggleNotification: org.isToggleNotification,
                createdAt: org.createdAt,
                updatedAt: org.updatedAt,
                profile: newProfile,
                about: org.about,
                isNgo: org.isNgo,
              );
              allNgosList[idx] = updatedOrg;
              allNgosList.refresh();
            }
          }

          // Update followers count in the trending NGO list if present
          final tIdx = trendingNgoList.indexWhere((e) => e.id == ngoId);
          if (tIdx != -1) {
            final item = trendingNgoList[tIdx];
            final current = item.followersCount ?? 0;
            item.followersCount = current + 1;
            trendingNgoList[tIdx] = item;
            trendingNgoList.refresh();
          }

          // Remove loading state and show success
          loadingFollowingIds.remove(ngoId);
          if (kDebugMode) debugPrint('Already following NGO, updated local state and counts');
          EasyLoading.showSuccess('Already following');
          return;
        }
      }
      
      if (response.isSuccess && resBody != null && resBody['success'] == true) {
        // Toggle the status
        final nowFollowing = !isCurrentlyFollowing;
        followStatus[ngoId] = nowFollowing;

        // Update followers count in NGOs list
        final idx = allNgosList.indexWhere((e) => e.id == ngoId);
        if (idx != -1) {
          final org = allNgosList[idx];
          if (org.profile != null) {
            final current = org.profile!.followersCount ?? 0;
            final newProfile = ProfileModel(
              id: org.profile!.id,
              parentId: org.profile!.parentId,
              name: org.profile!.name,
              username: org.profile!.username,
              title: org.profile!.title,
              bio: org.profile!.bio,
              avatarUrl: org.profile!.avatarUrl,
              coverUrl: org.profile!.coverUrl,
              location: org.profile!.location,
              balance: org.profile!.balance,
              followersCount: nowFollowing ? current + 1 : (current > 0 ? current - 1 : 0),
              followingCount: org.profile!.followingCount,
              createdAt: org.profile!.createdAt,
              updatedAt: org.profile!.updatedAt,
            );
            final updatedOrg = OrganizationModel(
              id: org.id,
              ownerId: org.ownerId,
              foundationDate: org.foundationDate,
              type: org.type,
              likes: org.likes,
              isVerified: org.isVerified,
              capLevel: org.capLevel,
              isToggleNotification: org.isToggleNotification,
              createdAt: org.createdAt,
              updatedAt: org.updatedAt,
              profile: newProfile,
              about: org.about,
              isNgo: org.isNgo,
            );
            allNgosList[idx] = updatedOrg;
            allNgosList.refresh();
          }
        }

        // Also update followers count in the trending NGO list if present
        final tIdx = trendingNgoList.indexWhere((e) => e.id == ngoId);
        if (tIdx != -1) {
          final item = trendingNgoList[tIdx];
          final current = item.followersCount ?? 0;
          item.followersCount = nowFollowing ? current + 1 : (current > 0 ? current - 1 : 0);
          trendingNgoList[tIdx] = item;
          trendingNgoList.refresh();
        }

        EasyLoading.showSuccess(resBody['message'] ?? (nowFollowing ? 'Followed' : 'Unfollowed'));
      } else {
        final msg = resBody != null && resBody['message'] != null ? resBody['message'].toString() : 'Follow request failed';
        if (kDebugMode) debugPrint('toggleNgoFollow failed: $msg | response: $resBody');
        EasyLoading.showError(msg);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('toggleNgoFollow error: $e');
      EasyLoading.showError('Something went wrong');
    } finally {
      loadingFollowingIds.remove(ngoId);
    }
  }

  // ------------------ toggle follow (POST-only toggle) ------------------
  Future<void> toggleFollow(String followingId, int index) async {
    if (followingId.isEmpty) return;
    if (loadingFollowingIds.contains(followingId)) return;

    loadingFollowingIds.add(followingId);

    try {
      final body = {'followingId': followingId};
      final response = await HttpNetworkClient().postRequest(url: Urls.follows, body: body);
      final resBody = response.responseData;
      if (response.isSuccess && resBody != null && resBody['success'] == true) {
        final message = (resBody['message'] ?? '').toString().toLowerCase();
        final data = resBody['data'];

        bool nowFollowing;
        if (message.contains('unfollow') ||
            message.contains('unfollowed') ||
            (data is Map && data.containsKey('count'))) {
          nowFollowing = false;
        } else {
          nowFollowing = true;
        }

        followStatus[followingId] = nowFollowing;

        if (nowFollowing && data is Map && data['id'] != null) {
          followRecordIdByFollowingId[followingId] = data['id'].toString();
        } else if (!nowFollowing) {
          followRecordIdByFollowingId.remove(followingId);
        }

        // update followers count in whichever lists contain this id
        void updateCountInList(RxList<TrendingDataModel> list) {
          final idx = list.indexWhere((e) => e.id == followingId);
          if (idx != -1) {
            final item = list[idx];
            final current = item.followersCount ?? 0;
            item.followersCount = nowFollowing ? current + 1 : (current > 0 ? current - 1 : 0);
            list[idx] = item;
            list.refresh();
          }
        }

        updateCountInList(trendingDataList);
        updateCountInList(trendingCommunityList);
        updateCountInList(trendingNgoList);

        // Update followers count in OrganizationModel lists
        void updateOrgCountInList(RxList<OrganizationModel> list) {
          final idx = list.indexWhere((e) => e.id == followingId);
          if (idx != -1) {
            final org = list[idx];
            if (org.profile != null) {
              final current = org.profile!.followersCount ?? 0;
              final newProfile = ProfileModel(
                id: org.profile!.id,
                parentId: org.profile!.parentId,
                name: org.profile!.name,
                username: org.profile!.username,
                title: org.profile!.title,
                bio: org.profile!.bio,
                avatarUrl: org.profile!.avatarUrl,
                coverUrl: org.profile!.coverUrl,
                location: org.profile!.location,
                balance: org.profile!.balance,
                followersCount: nowFollowing ? current + 1 : (current > 0 ? current - 1 : 0),
                followingCount: org.profile!.followingCount,
                createdAt: org.profile!.createdAt,
                updatedAt: org.profile!.updatedAt,
              );
              final updatedOrg = OrganizationModel(
                id: org.id,
                ownerId: org.ownerId,
                foundationDate: org.foundationDate,
                type: org.type,
                likes: org.likes,
                isVerified: org.isVerified,
                capLevel: org.capLevel,
                isToggleNotification: org.isToggleNotification,
                createdAt: org.createdAt,
                updatedAt: org.updatedAt,
                profile: newProfile,
                about: org.about,
                isNgo: org.isNgo,
              );
              list[idx] = updatedOrg;
              list.refresh();
            }
          }
        }

        updateOrgCountInList(allCommunitiesList);
        updateOrgCountInList(allNgosList);

        EasyLoading.showSuccess(resBody['message'] ?? (nowFollowing ? 'Followed' : 'Unfollowed'));
      } else {
        final msg = resBody != null && resBody['message'] != null ? resBody['message'].toString() : 'Follow request failed';
        if (kDebugMode) debugPrint('toggleFollow failed: $msg | response: $resBody');
        EasyLoading.showError(msg);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('toggleFollow error: $e');
      EasyLoading.showError('Something went wrong');
    } finally {
      loadingFollowingIds.remove(followingId);
    }
  }

  // ------------------ toggle friend request for NGO owner ------------------
  Future<void> toggleFriendRequest(String ownerId) async {
    if (ownerId.isEmpty) return;
    if (loadingFriendRequestIds.contains(ownerId)) return;

    loadingFriendRequestIds.add(ownerId);

    try {
      final response = await FriendRequestService.sendFriendRequest(
        receiverId: ownerId,
      );
      
      if (response != null && response.responseData?['success'] == true) {
        // Toggle the status
        final currentStatus = friendRequestStatus[ownerId] ?? false;
        friendRequestStatus[ownerId] = !currentStatus;
        EasyLoading.showSuccess(response.responseData?['message'] ?? 'Friend request sent');
      } else {
        EasyLoading.showError(response?.responseData?['error'] ?? 'Failed to send friend request');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('toggleFriendRequest error: $e');
      EasyLoading.showError('Something went wrong');
    } finally {
      loadingFriendRequestIds.remove(ownerId);
    }
  }

  /// Perform local search based on search query
  void performSearch(String query) {
    searchQuery.value = query.toLowerCase().trim();

    if (searchQuery.value.isEmpty) {
      // If search is empty, show all items
      filteredTrendingDataList.value = trendingDataList;
      filteredCommunitiesList.value = allCommunitiesList;
      filteredNgosList.value = allNgosList;
    } else {
      // Filter trending data
      filteredTrendingDataList.value = trendingDataList.where((item) {
        final name = (item.name ?? '').toLowerCase();
        final username = (item.username ?? '').toLowerCase();
        final title = (item.title ?? '').toLowerCase();
        return name.contains(searchQuery.value) || 
               username.contains(searchQuery.value) ||
               title.contains(searchQuery.value);
      }).toList();

      // Filter communities
      filteredCommunitiesList.value = allCommunitiesList.where((org) {
        final name = (org.profile?.name ?? '').toLowerCase();
        final location = (org.profile?.location ?? '').toLowerCase();
        return name.contains(searchQuery.value) || location.contains(searchQuery.value);
      }).toList();

      // Filter NGOs
      filteredNgosList.value = allNgosList.where((org) {
        final name = (org.profile?.name ?? '').toLowerCase();
        final location = (org.profile?.location ?? '').toLowerCase();
        return name.contains(searchQuery.value) || location.contains(searchQuery.value);
      }).toList();
    }
  }
}

// follow button toggle (kept for compatibility)
class FollowController extends GetxController {
  RxBool isFollowing = false.obs;

  void toggleFollow() {
    isFollowing.value = !isFollowing.value;
  }
}

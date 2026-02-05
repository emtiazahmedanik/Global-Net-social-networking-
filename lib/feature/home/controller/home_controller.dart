import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/friend_request_service/friend_request_service.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_file.dart';
import 'package:jdadzok/feature/home/model/comment_response_model.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';
import 'package:jdadzok/feature/home/service/feed_api_service.dart';
import '../model/category_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final feedService = FeedService();
  RxBool isFeedPostLoading = false.obs;

  final RxList<Category> categories = <Category>[].obs;
  final RxString searchText = ''.obs;
  final searchController = TextEditingController();
  RxList<PostModel> feedResponseList = <PostModel>[].obs;
  RxString userId = ''.obs;

  RxBool isMoreLoading = false.obs;

  int currentPage = 1;
  int totalPages = 1;

  // Scroll controller
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initializeCategories();
    loadFirstPage();
    // Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        loadNextPage();
      }
    });
  }

  //###################
  //load feed
  //###################

  // Future<void> loadFeed() async {
  //   userId.value = await SharedPreferencesHelper.getUserId() ?? '';
  //   debugPrint('userId: ${userId.value}');
  //   isFeedPostLoading.value = true;
  //   try {
  //     FeedResponse? feed = await feedService.fetchFeed();

  //     if (feed != null) {
  //       feedResponseList.value = feed.data;

  //       debugPrint("Loaded: ${feed.data.length} posts");
  //     }
  //   } catch (e) {
  //     debugPrint('$e');
  //   } finally {
  //     isFeedPostLoading.value = false;
  //   }
  // }

  // ================================
  // Load First Page
  // ================================
  Future<void> loadFirstPage() async {
    isFeedPostLoading.value = true;

    try {
      final feed = await feedService.fetchFeed(1);
      debugPrint("first page loaded: ${feed?.data.length}");
      if (feed != null) {
        feedResponseList.assignAll(feed.data);
        currentPage = feed.metadata.page ?? 1;
        totalPages = feed.metadata.totalPages ?? 1;
      }
      debugPrint("first page loaded: ${feedResponseList.length}");
    } catch (e) {
      debugPrint("Feed Error: $e");
    } finally {
      isFeedPostLoading.value = false;
    }
  }

  // ================================
  // Load Next Page (Pagination)
  // ================================
  Future<void> loadNextPage() async {
    if (isMoreLoading.value) return;
    if (currentPage >= totalPages) return;

    isMoreLoading.value = true;

    try {
      final nextPage = currentPage + 1;
      final feed = await feedService.fetchFeed(nextPage);

      if (feed != null) {
        feedResponseList.addAll(feed.data);
        currentPage = nextPage;
      }
    } catch (e) {
      debugPrint("Pagination Error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  //###################
  //like a post api call
  //###################

  Future<void> likePostApiCall({required String postId}) async {
    try {
      final body = {"postId": postId};
      final response = await HttpNetworkClient().postRequest(
        url: Urls.likes,
        body: body,
      );
      final responseBody = response.responseData;
      if (responseBody?['success'] == true) {
        debugPrint('liked successful');
      } else {
        EasyLoading.showError('${responseBody?['message']}');
      }
    } catch (e) {
      debugPrint('like on post error : $e');
    }
  }

  //###################
  //load comment from api
  //###################

  RxList<CommentResponseModel> commentList = <CommentResponseModel>[].obs;

  Future<void> fetchCommentData(String id) async {
    commentList.clear();
    final token = await SharedPreferencesHelper.getAccessToken();
    Map<String, String> header = {"Authorization": "Bearer $token"};
    try {
      final uri = Uri.parse(Urls.getComment(id));
      final response = await http.get(uri, headers: header);
      final body = jsonDecode(response.body);
      debugPrint('comment response: $body');
      if (response.statusCode == 200) {
        if (body is List) {
          for (var data in body) {
            CommentResponseModel model = CommentResponseModel.fromJson(data);
            commentList.add(model);
          }
        }
      }
    } catch (e) {
      debugPrint('comment error : $e');
    }
  }

  //###################
  // comment on a post api call
  //###################

  RxBool isSheetUpdate = false.obs;
  RxString selectedCommentFilePath = ''.obs;

  Future<void> commentOnPostApiCall({
    required String postId,
    String? parentCommentId,
    required String text,
  }) async {
    String uploadImageUrl = '';
    if (selectedCommentFilePath.value.isNotEmpty) {
      final String url = await UploadAwsFile.uploadFile(
        File(selectedCommentFilePath.value),
      );
      uploadImageUrl = url;
    }

    if (text.isNotEmpty || uploadImageUrl.isNotEmpty) {
      try {
        final body = {
          "postId": postId,
          "text": text,
          "mediaUrl": uploadImageUrl,
          "mediaType": "IMAGE",
        };
        if (parentCommentId != null) {
          body.addAll({"parentCommentId": parentCommentId});
        }

        debugPrint('final body before comment : $body');

        EasyLoading.show();

        final response = await HttpNetworkClient().postRequest(
          url: Urls.commentOnPost,
          body: body,
        );
        final responseBody = response.responseData;

        debugPrint('comment posted response : $responseBody');

        if (responseBody != null) {
          EasyLoading.dismiss();
          fetchCommentData(postId);
          debugPrint('comment successfully posted');
          isSheetUpdate.value = true;
          selectedCommentFilePath.value = '';
        }
      } catch (e) {
        EasyLoading.dismiss();

        debugPrint('comment post error : $e');
      }
    }
  }

  //###################
  //share post api call
  //###################

  Future<void> sharePostApiCall(String id) async {
    EasyLoading.show();
    try {
      final body = {"postId": id};
      final response = await HttpNetworkClient().postRequest(
        url: Urls.sharePost,
        body: body,
      );
      final responseBody = response.responseData;
      if (responseBody != null && responseBody['success'] == true) {
        EasyLoading.showSuccess('post shared');
      } else {
        debugPrint('api error : $responseBody');
      }
    } catch (e) {
      debugPrint('sahre post error: $e');
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
  }

  //###################
  //send friend request
  //###################

  Future<void> sendFriendRequest({required String userId}) async {
    EasyLoading.show();

    try {
      final HttpNetworkResponse? response =
          await FriendRequestService.sendFriendRequest(receiverId: userId);

      if (response != null) {
        final responseBody = response.responseData;
        debugPrint('this is friend : $responseBody');
        if (responseBody?['success'] == true) {
          EasyLoading.showSuccess("Friend request sent");
        } else {
          EasyLoading.showError(responseBody?['error']);
        }
      }
    } catch (e) {
      debugPrint('this is sent req error $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  //###################
  //save post
  //###################

  Future<void> savePost({required String postId}) async {
    EasyLoading.show();

    try {
      final body = {'postId': postId};

      final HttpNetworkResponse response = await HttpNetworkClient()
          .postRequest(url: Urls.savePost, body: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = response.responseData;
        debugPrint('this is save post : $responseBody');
        if (responseBody?['success'] == true) {
          EasyLoading.showSuccess("Post saved");
        } else {
          EasyLoading.showError(responseBody?['error']);
        }
      }
    } catch (e) {
      debugPrint('this is save post error $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  //###################
  //hide post
  //###################

  Future<void> hidePost({required String postId}) async {
    EasyLoading.show();

    try {
      final body = {"hide": true};

      final HttpNetworkResponse response = await HttpNetworkClient()
          .patchRequest(url: Urls.hidePost(postId), body: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = response.responseData;
        debugPrint('this is hide post : $responseBody');
        if (responseBody?['success'] == true) {
          EasyLoading.showSuccess("Post hidden");
          loadFirstPage();
        } else {
          EasyLoading.showError(responseBody?['error']);
        }
      }
    } catch (e) {
      debugPrint('this is hide error $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  //###################
  //report post
  //###################

  Future<void> reportPost({
    required String postId,
    required String reason,
  }) async {
    EasyLoading.show();

    try {
      final body = {"targetType": "USER", "targetId": postId, "reason": reason};

      final HttpNetworkResponse response = await HttpNetworkClient()
          .postRequest(url: Urls.submitReport, body: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = response.responseData;
        debugPrint('this is hide post : $responseBody');
        if (responseBody?['success'] == true) {
          EasyLoading.showSuccess("Report Submitted");
          loadFirstPage();
        } else {
          EasyLoading.showError(responseBody?['error']);
        }
      }
    } catch (e) {
      debugPrint('this is hide error $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void onTapSearch() async {
    isFeedPostLoading.value = true;
    debugPrint('search tapped');
    final response = await feedService.fetchFeed(
      1,
      search: searchController.text,
    );
    debugPrint('search response: ${response?.data.length}');
    if (response != null) {
      feedResponseList.assignAll(response.data);
      feedResponseList.refresh();
      if (feedResponseList.isNotEmpty) {
        debugPrint('search response: ${feedResponseList.first.id}');
      } else {
        debugPrint('search response: 0 (no results)');
      }
      currentPage = response.metadata.page ?? 1;
      totalPages = response.metadata.totalPages ?? 1;
    }

    isFeedPostLoading.value = false;
  }

  void _initializeCategories() {
    categories.value = [
      Category(id: '0', name: 'All', emoji: '', isSelected: true),
      Category(
        id: '1',
        name: 'Entertainment & Pop Culture',
        emoji: '😆',
        
      ),
      Category(id: '2', name: 'Science & Education', emoji: '🧐'),
      Category(id: '3', name: 'Auto', emoji: '🚗'),
      Category(id: '4', name: 'Travel', emoji: '🏖️'),
      Category(id: '5', name: 'Sports', emoji: '🏀'),
      Category(id: '6', name: 'Art', emoji: '🎨'),
      Category(id: '7', name: 'Beauty & Style', emoji: '💄'),
      Category(id: '8', name: 'Animals', emoji: '😺'),
      Category(id: '9', name: 'Gaming', emoji: '🎮'),
      Category(id: '10', name: 'Food', emoji: '🍔'),
      Category(id: '11', name: 'Life Hacks', emoji: '💡'),
      Category(id: '12', name: 'DIY', emoji: '✂️'),
      Category(id: '13', name: 'Music', emoji: '🎵'),
      Category(id: '14', name: 'Dance', emoji: '💃'),
    ];
  }

  void selectCategory(String categoryId) {
    categories.value = categories.map((category) {
      return category.copyWith(isSelected: category.id == categoryId);
    }).toList();
    if(categoryId != '0'){
      onTapCategory(
        categories.firstWhere((cat) => cat.id == categoryId).name,
      );
    }else{
      loadFirstPage();
    }
  }

    void onTapCategory(String category) async {
    isFeedPostLoading.value = true;
    debugPrint('search tapped');
    final response = await feedService.fetchFeed(
      1,
      search: category,
    );
    debugPrint('search response: ${response?.data.length}');
    if (response != null) {
      feedResponseList.assignAll(response.data);
      feedResponseList.refresh();
      if (feedResponseList.isNotEmpty) {
        debugPrint('search response: ${feedResponseList.first.id}');
      } else {
        debugPrint('search response: 0 (no results)');
      }
      currentPage = response.metadata.page ?? 1;
      totalPages = response.metadata.totalPages ?? 1;
    }

    isFeedPostLoading.value = false;
  }

  void updateSearchText(String text) {
    searchText.value = text;
  }
}

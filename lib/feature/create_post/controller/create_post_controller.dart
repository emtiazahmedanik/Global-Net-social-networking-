
// ignore_for_file: avoid_init_to_null, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/services_class/friend_request_service/all_friend_request_service.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_file.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_video.dart';
import 'package:jdadzok/feature/create_post/service/create_post_api_service.dart';
import 'package:jdadzok/feature/friend_request/all_friend_request/model/all_friend_request_model.dart';

import 'package:video_player/video_player.dart';

enum PrivacyOption { public, followers, private }

enum MediaType { none, image, video }

class CreatePostController extends GetxController {
  late VideoPlayerController? videoController = null;
  final TextEditingController textController = TextEditingController();

  // MEDIA STATE
  final RxString selectedMediaPath = ''.obs;
  final Rx<MediaType> mediaType = MediaType.none.obs;
  final RxBool hasMedia = false.obs;
  var isVideoInitialized = false.obs;

  // UI STATE
  final RxBool isModalCollapsed = false.obs;
  final RxString postText = ''.obs;
  final RxBool isPosting = false.obs;

  // PRIVACY
  var selectedPrivacy = PrivacyOption.public.obs;

  // TAGGED USER
  final RxList taggedUserId = <String>[].obs;
  final RxString taggedUserName = ''.obs;

  // FEELING / ACTIVITY
  final RxString selectedFeeling = ''.obs;
  static const List<String> feelings = [
    "HAPPY",
    "SAD",
    "ANGRY",
    "AMAZED",
    "AMUSED",
    "SCARED",
    "PROUD",
    "TIRED",
    "CONFUSED",
    "RELAXED",
    "EXCITED",
    "WORRIED",
    "LOVED",
    "GRATEFUL",
    "BLESSED",
    "HUNGRY",
    "HOPEFUL",
    "LONELY",
    "SILLY",
    "THANKFUL",
    "AWESOME",
    "BORED",
    "COOL",
    "DETERMINED",
    "IN_LOVE",
    "INSPIRED",
    "MOTIVATED",
    "SICK",
    "SLEEPY",
    "STRESSED",
    "STRONG",
    "FUNNY",
    "MEH",
  ];

  bool get canPost =>
      (postText.value.trim().isNotEmpty || hasMedia.value) && !isPosting.value;

  String get displayText {
    switch (selectedPrivacy.value) {
      case PrivacyOption.public:
        return 'Public';
      case PrivacyOption.followers:
        return 'Followers';
      case PrivacyOption.private:
        return 'Private';
    }
  }

  void setPrivacy(PrivacyOption? value) {
    if (value != null) {
      selectedPrivacy.value = value;
    }
  }

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      postText.value = textController.text;
      _updateModalState();
    });
  }

  void _updateModalState() {
    isModalCollapsed.value = postText.value.isNotEmpty || hasMedia.value;
  }

  // -------------------------------------------------------
  //              PICK IMAGE OR VIDEO
  // -------------------------------------------------------
  Future<void> pickPhotoVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        String path = result.files.single.path!;
        selectedMediaPath.value = path;
        hasMedia.value = true;

        String ext = path.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png'].contains(ext)) {
          mediaType.value = MediaType.image;

          // Dispose old video controller
          videoController?.dispose();
          videoController = null;
        } else {
          mediaType.value = MediaType.video;

          videoController?.dispose();
          videoController = VideoPlayerController.file(File(path));
          await videoController!.initialize().then((_) {
            isVideoInitialized.value = true;
            videoController!.setLooping(true);
          });

          videoController!.setLooping(true);
        }

        _updateModalState();
        //EasyLoading.showSuccess('Media selected successfully');
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick media: $e');
    }
  }

  // -------------------------------------------------------
  //              REMOVE MEDIA
  // -------------------------------------------------------
  void removeMedia() {
    selectedMediaPath.value = '';
    mediaType.value = MediaType.none;
    hasMedia.value = false;

    videoController?.dispose();
    videoController = null;

    _updateModalState();
  }

  // -------------------------------------------------------
  //              OTHER ACTIONS
  // -------------------------------------------------------
  void tagPeople() {
    // Open tag people dialog using current context
    final ctx = Get.context;
    if (ctx != null) {
      showTagPeopleDialog(ctx);
    }
  }

  /// Show a bottom sheet with friends list to pick one user to tag
  Future<void> showTagPeopleDialog(BuildContext context) async {
    // Ensure friends are loaded
    if (friends.isEmpty) {
      await loadFriends();
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Tag a friend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (isFriendsLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (friends.isEmpty) {
                  return const Center(child: Text('No friends found'));
                }
                return ListView.separated(
                  itemCount: friends.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final f = friends[index];
                    bool isSelected;
                    if(taggedUserId.isNotEmpty){
                      isSelected = taggedUserId.contains(f.id);
                    } else {
                      isSelected = false;
                    }
                    return ListTile(
                      leading: f.avatarUrl != null && f.avatarUrl!.isNotEmpty
                          ? CircleAvatar(backgroundImage: NetworkImage(f.avatarUrl!))
                          : CircleAvatar(child: Text(f.name.isNotEmpty ? f.name[0] : '?')),
                      title: Text(f.name),
                      subtitle: Text(f.email, overflow: TextOverflow.ellipsis),
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                      onTap: () {
                        taggedUserId.add(f.id);
                        taggedUserName.value = f.name;
                        Get.back();
                        EasyLoading.showSuccess('Tagged ${f.name}');
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  void addFeelingActivity() {
    final ctx = Get.context;
    if (ctx != null) showFeelingActivityDialog(ctx);
  }

  /// Show a bottom sheet to pick a feeling/activity
  Future<void> showFeelingActivityDialog(BuildContext context) async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            const Text('How are you feeling?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                itemCount: feelings.length,
                itemBuilder: (context, index) {
                  final f = feelings[index];
                  final display = f.replaceAll('_', ' ').toLowerCase();
                  final cap = display.isNotEmpty ? '${display[0].toUpperCase()}${display.substring(1)}' : f;
                  final isSelected = selectedFeeling.value == f;
                  return GestureDetector(
                    onTap: () {
                      selectedFeeling.value = f;
                      Get.back();
                      EasyLoading.showSuccess('Selected: $cap');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
                      ),
                      child: Text(cap, style: const TextStyle(fontSize: 14)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void checkIn() => EasyLoading.showInfo('Check in functionality coming soon');
  void addGif() => EasyLoading.showInfo('GIF functionality coming soon');

  // -------------------------------------------------------
  //               CREATE POST
  // -------------------------------------------------------
  void createPost() async {
    if (!canPost) return;

    if (postText.value.trim().isEmpty && !hasMedia.value) {
      EasyLoading.showError('Please add some content to your post');
      return;
    }

    isPosting.value = true;

    //call create post here
    await createPostApiCall();

    Future.delayed(const Duration(milliseconds: 1500), () {
      textController.clear();
      removeMedia();
      isPosting.value = false;

      Get.back();
      Future.delayed(const Duration(milliseconds: 300), () {
        // EasyLoading.showSuccess('Post shared successfully!');
      });
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  //post data to backend api

  Future<void> createPostApiCall() async{
    final token = await SharedPreferencesHelper.getAccessToken();

    String uploadedUrl = '';
    if(selectedMediaPath.value.isNotEmpty && mediaType.value == MediaType.video){
      uploadedUrl =  await UploadAwsVideo.uploadVideo(File(selectedMediaPath.value));
    }
    if(selectedMediaPath.value.isNotEmpty && mediaType.value == MediaType.image){
      uploadedUrl =  await UploadAwsFile.uploadFile(File(selectedMediaPath.value));
    }

    final isSuccess = await createPostApiService(
      token: token ?? '',
      text: textController.text.trim(),
      mediaUrls: [uploadedUrl],
      mediaType: mediaType.value.name.toUpperCase(),
      metadata: {
        'feeling': selectedFeeling.value,
      },
      visibility: selectedPrivacy.value.name.toUpperCase(),
      postFrom: "REGULAR_PROFILE",
      taggedUserIds: taggedUserId,
    );

    if(isSuccess){
      EasyLoading.showSuccess('Post submitted');
    }else{
      EasyLoading.showError("Post Failed");
    }

  }

  RxList<AllFriendRequestModel> friends = <AllFriendRequestModel>[].obs;
  RxBool isFriendsLoading = false.obs;
    Future<void> loadFriends() async {
    try {
      isFriendsLoading.value = true;

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
      isFriendsLoading.value = false;
    }
  }
  
}

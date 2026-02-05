// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_file.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_video.dart';
import 'package:jdadzok/feature/chat/chat_service/chat_service.dart';
import 'package:jdadzok/feature/chat/model/message_model.dart';
import 'package:jdadzok/feature/chat/model/participent_list_model.dart';

class ChatController extends GetxController {
  String? receiverId = Get.arguments ?? ''; // Passed from previous screen

  RxString selectedUserId = ''.obs;
  RxString selectedChatId = ''.obs;
  RxInt selectedChatIndex = 0.obs;

  final ChatService _chatService = ChatService();

  final messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  RxString userId = ''.obs;
  RxString chatId = ''.obs;

  RxList messages = [].obs; // chat messages

  RxBool loading = false.obs;
  RxBool loadingMore = false.obs;

  RxString selectedMediaPath = ''.obs;
  RxString uploadedMediaUrl = ''.obs;
  RxString mediaType = ''.obs;

  final ImagePicker picker = ImagePicker();

  // Receiver info for displaying in header
  RxString receiverName = ''.obs;
  RxString receiverAvatar = ''.obs;
  RxBool isLoadingReceiverInfo = false.obs;

  // Call manager

  RxBool callManagerInitialized = false.obs;

  // ===========================
  // INIT
  // ===========================
  @override
  void onInit() {
    super.onInit();
    selectedUserId.value = receiverId ?? '';
    _initializeChat();
    getAllParticiepnt();

    // If a receiverId was provided (e.g. from Product Detail), fetch or create the chat
    if (receiverId != null && receiverId!.isNotEmpty) {
      debugPrint('receiverId present on init, fetching chat id...');
      getChatIdWithUser();
    }

    // Automatically load messages when selectedChatId is set (e.g., from ChatScreen)
    ever<String>(selectedChatId, (val) {
      // ignore: unnecessary_null_comparison
      if (val != null && val.isNotEmpty) {
        debugPrint('selectedChatId changed, loading messages for: $val');
        getAllMessages();
      }
    });

    // If selectedChatId was already provided before controller init, load messages
    if (selectedChatId.value.isNotEmpty) {
      debugPrint(
        'selectedChatId present on init, loading messages: ${selectedChatId.value}',
      );
      getAllMessages();
    }
  }

  Future<void> _initializeChat() async {
    await _loadUserId();
    if (kDebugMode) {
      print(" receiverId: $receiverId");
      print(" userId: ${userId.value}");
    }
    await _initSocket();
    //await loadMessages();
  }

  // ===========================
  // GET CHAT ID FOR A RECEIVER
  // ===========================
  Future<void> getChatIdWithUser() async {
    if (receiverId == null || receiverId!.isEmpty) {
      debugPrint('receiver id is null or empty');
      return;
    }

    debugPrint('Fetching chat ID for receiverId: $receiverId');

    // Fetch receiver's profile info
    await fetchReceiverProfile();

    try {
      final response = await HttpNetworkClient().getRequest(
        url: Urls.getChatIdWithUser(receiverId!),
      );
      final body = response.responseData;
      debugPrint('chat id response: $body');

      if (response.statusCode == 200) {
        final fetchedChatId = body?['id'] ?? '';
        if (fetchedChatId.isEmpty) {
          debugPrint('Chat ID is empty from response');
          return;
        }
        chatId.value = fetchedChatId;
        selectedChatId.value = chatId.value;
        debugPrint('Chat ID set: ${selectedChatId.value}');
        await getAllMessages();
      } else {
        debugPrint('Failed to get chat ID: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('chat id error : $e');
    }
  }

  // ===========================
  // FETCH RECEIVER PROFILE INFO
  // ===========================
  Future<void> fetchReceiverProfile() async {
    if (selectedUserId.isEmpty) {
      debugPrint('selectedUserId is empty');
      return;
    }
    

    try {
      isLoadingReceiverInfo.value = true;
      final response = await HttpNetworkClient().getRequest(
        url: '${Urls.getUserProfile}/${selectedUserId.value}',
      );

      debugPrint('receiver profile response: ${response.responseData}');

      if (response.statusCode == 200) {
        final data = response.responseData;
        receiverName.value = data?['data']?['profile']?['name'] ?? '';
        receiverAvatar.value = data?['data']?['profile']?['avatarUrl'] ?? '';
        debugPrint('Receiver info fetched: ${receiverName.value}');
      }
    } catch (e) {
      debugPrint('Error fetching receiver profile: $e');
    } finally {
      isLoadingReceiverInfo.value = false;
    }
  }

  Future<void> _loadUserId() async {
    userId.value = await SharedPreferencesHelper.getUserId() ?? '';
  }

  // ===========================
  // SOCKET INIT
  // ===========================
  Future<void> _initSocket() async {
    await _chatService.getToken();
    _chatService.connect();

    debugPrint('inside init socket');

    // Listen for new messages
    _chatService.on('chat:message_receive', (data) {
      messageList.add(MessageModel.fromJson(data));
      debugPrint('new message received: $data');
      scrollToBottom();
    });

    // Listen for message sent confirmation
    _chatService.on('chat:message_sent', (data) {
      messageList.add(MessageModel.fromJson(data));
      debugPrint('message sent: $data');
      scrollToBottom();
    });

    // Listen for read receipts
    _chatService.on('chat:message_read', (data) {
      debugPrint("Message read: ${jsonDecode(data)}");
    });

    // Errors
    _chatService.on('error', (data) {
      debugPrint("Socket error: $data");
    });
  }

  // ===========================
  // MEDIA PICKING
  // ===========================
  Future<void> pickMedia(String type) async {
    XFile? file;

    if (type == "IMAGE") {
      file = await picker.pickImage(source: ImageSource.gallery);
    } else if (type == "VIDEO") {
      file = await picker.pickVideo(source: ImageSource.gallery);
    } else {
      return;
    }

    if (file != null) {
      selectedMediaPath.value = file.path;
      mediaType.value = type;
      //await uploadMedia();
    }
  }

  // ===========================
  // ATTACHMENT SHEET
  // ===========================
  void openAttachmentSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Send Image"),
              onTap: () {
                pickMedia("IMAGE");
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_collection),
              title: const Text("Send Video"),
              onTap: () {
                pickMedia("VIDEO");
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================
  // UPLOAD MEDIA
  // ===========================
  Future<void> uploadMedia() async {
    if (mediaType.value == 'IMAGE') {
      uploadedMediaUrl.value = await UploadAwsFile.uploadFile(
        File(selectedMediaPath.value),
      );
    } else if (mediaType.value == 'VIDEO') {
      uploadedMediaUrl.value = await UploadAwsVideo.uploadVideo(
        File(selectedMediaPath.value),
      );
    }
  }

  // ===========================
  // SEND MESSAGE
  // ===========================
  void sendMessage(String content) async {
    debugPrint('inside send');
    if (content.trim().isNotEmpty || uploadedMediaUrl.value.isNotEmpty) {
      if (selectedMediaPath.value.isNotEmpty) {
        debugPrint('msg image uploading');
        await uploadMedia();
      }
      final payload = {
        "receiverId": selectedUserId.value,
        "content": content,
        "mediaUrl": uploadedMediaUrl.value.isEmpty
            ? null
            : uploadedMediaUrl.value,
        "mediaType": mediaType.value.isEmpty ? null : mediaType.value,
      };

      debugPrint('payload before send: $payload');

      _chatService.emit("chat:message_send", payload);

      uploadedMediaUrl.value = '';
      selectedMediaPath.value = '';
      mediaType.value = '';
      messageController.clear();

      scrollToBottom();
    }
  }

  // ===========================
  // MARK MESSAGE AS READ
  // ===========================
  void markAsRead(String messageId) {
    _chatService.emit("chat:message_read", {"messageId": messageId});
  }

  // ===========================
  // SCROLL TO BOTTOM
  // ===========================
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ===========================
  // FORMAT TIME
  // ===========================
  String formatTime(String createdAt) {
    final time = DateTime.tryParse(createdAt);
    if (time == null) return "";
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  RxList<ParticipentListModel> participantsList = <ParticipentListModel>[].obs;
  Future<void> getAllParticiepnt() async {
    try {
      EasyLoading.show();
      String accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';
      final String currentUserId =
          await SharedPreferencesHelper.getUserId() ?? '';
      final header = {'authorization': 'Bearer $accessToken'};
      final uri = Uri.parse(Urls.getMychatPaticipent);
      final response = await http.get(uri, headers: header);
      final responseBody = jsonDecode(response.body);
      debugPrint('this is partiresponse : $responseBody');
      if (response.statusCode == 200) {
        participantsList.clear();
        if (responseBody is List) {
          for (var data in responseBody) {
            ParticipentListModel model = ParticipentListModel.fromJson(
              data,
              currentUserId,
            );
            participantsList.add(model);
          }
        }
        debugPrint('parti list length : ${participantsList.length}');
        participantsList.refresh();
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('${responseBody['message']}');
      }
    } catch (e) {
      debugPrint('participent error : $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  RxList<MessageModel> messageList = <MessageModel>[].obs;
  Future<void> getAllMessages() async {
    fetchReceiverProfile();
    try {
      EasyLoading.show();
      String accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';
      final header = {'authorization': 'Bearer $accessToken'};
      final uri = Uri.parse(Urls.getAllMessageWithUser(selectedChatId.value));
      final response = await http.get(uri, headers: header);
      final responseBody = jsonDecode(response.body);
      debugPrint('this is message res : $responseBody');
      debugPrint('this is chat id : ${selectedChatId.value}');

      if (response.statusCode == 200) {
        messageList.clear();
        List<MessageModel> fetchedMessages = [];
        if (responseBody['messages'] is List) {
          for (var data in responseBody['messages']) {
            MessageModel model = MessageModel.fromJson(data);
            fetchedMessages.add(model);
          }
        }
        messageList.assignAll(
          fetchedMessages.reversed.toList(), // oldest → newest
        );
        debugPrint('message list length : ${messageList.length}');
        messageList.refresh();
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('${responseBody['message']}');
      }
    } catch (e) {
      debugPrint('message error : $e');
    } finally {
      EasyLoading.dismiss();
    }
  }
}

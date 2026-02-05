import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_view_button.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/services_class/friend_request_service/friend_request_service.dart';
import 'package:jdadzok/feature/chat/chat_controller/chat_controller.dart';
import 'package:jdadzok/route/app_route.dart';

class PublicProfileActionButton extends StatefulWidget {
  final String userId;
  const PublicProfileActionButton({super.key, required this.userId});

  @override
  State<PublicProfileActionButton> createState() =>
      _PublicProfileActionButtonState();
}

class _PublicProfileActionButtonState
    extends State<PublicProfileActionButton> {
  bool isSendingRequest = false;
  bool requestSent = false;

  Future<void> sendFriendRequest() async {
    if (isSendingRequest || requestSent) return;

    setState(() {
      isSendingRequest = true;
    });

    try {
      final HttpNetworkResponse? response =
          await FriendRequestService.sendFriendRequest(
              receiverId: widget.userId);

      if (response != null) {
        final responseBody = response.responseData;
        if (responseBody?['success'] == true) {
          EasyLoading.showSuccess("Friend request sent");
          setState(() {
            requestSent = true;
          });
        } else {
          EasyLoading.showError(
              responseBody?['message'] ?? 'Failed to send request');
        }
      } else {
        EasyLoading.showError('Failed to send friend request');
      }
    } catch (e) {
      EasyLoading.showError('Error sending friend request');
    } finally {
      setState(() {
        isSendingRequest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomViewButton(
            text: 'Send Message',
            color: Color(0XFF2D55FF),
            width: 247,
            onPressed: () {
              // Delete existing controller to ensure fresh state
              Get.delete<ChatController>();
              Get.toNamed(AppRoute.getIndividualChat(),
                  arguments: widget.userId);
            },
            textColor: Colors.white,
          ),
          GestureDetector(
            onTap: sendFriendRequest,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/icons/add_friend.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: isSendingRequest
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          GestureDetector(
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/icons/share_button_icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              EasyLoading.showSuccess('Shared');
            },
          ),
        ],
      ),
    );
  }
}

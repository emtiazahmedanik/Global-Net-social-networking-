import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/friend_request/all_friend_request/screen/all_frend_request_screen.dart';
import 'package:jdadzok/feature/friend_request/controller/friend_request_controller.dart';

class FriendRequestScreen extends StatelessWidget {
  FriendRequestScreen({super.key});

  final controller = Get.put(FriendRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Invitations",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AllFriendRequestScreen());
            },
            icon: const Icon(
              Icons.people_outline,
              color: Colors.black,
              size: 26,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.requests.isEmpty) {
          return const Center(child: Text("No pending invitations"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.requests.length,
          itemBuilder: (context, index) {
            final req = controller.requests[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      req.sender.profile.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          req.sender.profile.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          req.sender.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.acceptRequest(req.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Accept"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.rejectRequest(req.id);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Ignore",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

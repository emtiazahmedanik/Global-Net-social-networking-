import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/friend_request/all_friend_request/controller/all_friend_request_controller.dart';
import 'package:jdadzok/feature/public_view/screen/public_profile_view.dart';

class AllFriendRequestScreen extends StatelessWidget {
  AllFriendRequestScreen({super.key});

  final AllFriendRequestController controller = Get.put(
    AllFriendRequestController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "All Friends",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: Column(
        children: [
          //  Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => controller.searchText.value = value,
              decoration: InputDecoration(
                hintText: "Search friends...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.friends.isEmpty) {
                return const Center(child: Text("No friends found"));
              }

              final list = controller.filteredFriends;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final friend = list[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => PublicProfileView(userId: friend.id));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black.withValues(alpha: 0.03),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue.shade100,
                            backgroundImage: friend.avatarUrl != null
                                ? NetworkImage(friend.avatarUrl!)
                                : null,
                            child: friend.avatarUrl == null
                                ? Text(
                                    friend.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  friend.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  friend.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

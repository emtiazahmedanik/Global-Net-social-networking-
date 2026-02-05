// lib/feature/create_ngo/create_ngo_verify_screen/screen/create_ngo_verify_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/controller/create_ngo_verify_controller.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/widget/create_ngo_verify_head_body.dart';
import 'package:jdadzok/route/app_route.dart';

class CreateNgoVerifyProfileScreen extends StatefulWidget {
  final bool isNgo;

  const CreateNgoVerifyProfileScreen({super.key, required this.isNgo});

  @override
  State<CreateNgoVerifyProfileScreen> createState() =>
      _CreateNgoVerifyProfileScreenState();
}

class _CreateNgoVerifyProfileScreenState
    extends State<CreateNgoVerifyProfileScreen> {
  final CreateNgoVerifyController createNgoVerifyController = Get.put(
    CreateNgoVerifyController(),
  );

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fetch once (if not already fetching / loaded)
      if (createNgoVerifyController.items.isEmpty &&
          !createNgoVerifyController.isLoading.value) {
        if (widget.isNgo) {
          createNgoVerifyController.fetchMyNgos();
        } else {
          createNgoVerifyController.fetchMyCommunities();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: CircleAvatar(
                      backgroundColor: const Color(0XFFEFEFEF),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.isNgo ? "My NGOs" : "My Communities",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  // Loading
                  if (createNgoVerifyController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (createNgoVerifyController.error.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            createNgoVerifyController.error.value,
                            style: globalTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (widget.isNgo) {
                                createNgoVerifyController.fetchMyNgos();
                              } else {
                                createNgoVerifyController
                                    .fetchMyCommunities();
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Empty
                  if (createNgoVerifyController.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No ${widget.isNgo ? "NGO" : "Community"} found.",
                            style: globalTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (widget.isNgo) {
                                createNgoVerifyController.fetchMyNgos();
                              } else {
                                createNgoVerifyController
                                    .fetchMyCommunities();
                              }
                            },
                            child: const Text("Reload"),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show all items in a vertical list
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // List of items
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              createNgoVerifyController.items.length,
                          itemBuilder: (context, index) {
                            final org =
                                createNgoVerifyController.items[index];

                            return Obx(() {
                              final isSelected = createNgoVerifyController
                                      .selectedIndex.value ==
                                  index;

                              return GestureDetector(
                                onTap: () {
                                  createNgoVerifyController.selectedIndex.value =
                                      index;
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF1F41BB)
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: isSelected
                                      ? const Color(0xFF1F41BB)
                                          .withValues(alpha: 0.05)
                                      : Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: createNGOVerifyHeadBody(
                                            org: org,
                                            isNgo: widget.isNgo,
                                            showBackButton: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(height: 16),
                                      const Divider(),
                                      const SizedBox(height: 12),
                                      // Apply Verification button
                                      if (widget.isNgo) ...[
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                              AppRoute
                                                  .applyVerificationScreen,
                                              arguments: {
                                                'isNgo': widget.isNgo,
                                                'org': org
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "Apply Verification",
                                                style: globalTextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                  Icons
                                                      .arrow_forward_ios,
                                                  size: 16),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                      // Delete button
                                      GestureDetector(
                                        onTap: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                  'Confirm delete'),
                                              content: Text(
                                                'Are you sure you want to delete this ${widget.isNgo ? "NGO" : "Community"}?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          ctx, false),
                                                  child: const Text(
                                                      'Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          ctx, true),
                                                  child: const Text(
                                                      'Delete'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            createNgoVerifyController
                                                .chooseIndex(index);
                                            final deleted =
                                                await createNgoVerifyController
                                                    .deleteSelected(
                                                        isNgo:
                                                            widget.isNgo);

                                            if (deleted &&
                                                createNgoVerifyController
                                                    .items.isEmpty) {
                                              Get.back();
                                            }
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.isNgo
                                                  ? "Delete NGO"
                                                  : "Delete Community",
                                              style: globalTextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                            });
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

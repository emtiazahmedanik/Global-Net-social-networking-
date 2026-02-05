import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/marketplace/controller/create_ad_controller.dart';

class ShowGetDialog {

  

  static void showDiscardDialog() {
    final CreateAdController controller = Get.put(CreateAdController());
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 343,
          padding: const EdgeInsets.only(
            top: 10,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Discard Posting?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'You will loss everything you\'ve added so far',
                      style: TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.back(); // Close dialog first
                                controller.clearForm(); // Clear the form
                                // Use a slight delay to ensure dialog is closed
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () {
                                    controller.navigateBack(); // Safe navigation back
                                  },
                                );
                              },
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF2D55FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Discard',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.06,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Expanded(
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Get.back(); // Close dialog first
                          //       controller.saveDraft(); // Then save draft (shows EasyLoading)
                          //       controller.navigateBack(); // Navigate back immediately
                          //     },
                          //     child: Container(
                          //       height: 44,
                          //       padding: const EdgeInsets.all(10),
                          //       clipBehavior: Clip.antiAlias,
                          //       decoration: ShapeDecoration(
                          //         color: const Color(0xFFEFEFEF),
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(12),
                          //         ),
                          //       ),
                          //       child: const Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          //           Text(
                          //             'Save Draft',
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 16,
                          //               fontFamily: 'Inter',
                          //               fontWeight: FontWeight.w400,
                          //               height: 1.06,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


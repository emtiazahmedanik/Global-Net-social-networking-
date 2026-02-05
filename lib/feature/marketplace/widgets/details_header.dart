import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/marketplace/controller/product_details_controller.dart';

Widget buildHeader(ProductDetailsController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            controller.isFriendReqSent.value = false;
            Get.back();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    ),
  );
}

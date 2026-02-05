/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_profile_screen/widget/create_ngo_text_field.dart';

import '../../../core/global_widegts/custom_button.dart';
import '../controller/create_community_controller.dart';

class CreateCommunityScreen extends StatelessWidget {
  CreateCommunityScreen({super.key});

  final createCommunityController = Get.put(CreateCommunityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Left side back button (aligned to start)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              shape: const CircleBorder(),
                            ),
                            onPressed: Get.back,
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ],
                      ),
                    ),

                    // Center title
                    const Text(
                      'Create Community',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Right side empty space for balance
                    const Expanded(child: SizedBox()),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Community Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(ImagePath.profileImage001),
                    ),
                    SizedBox(width: 12),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                CreateNGOTextField(
                  labelName: 'Community Name',
                  hintName: 'Enter Name',
                ),
                // SizedBox(width: 12),
                CreateNGOTextField(
                  labelName: 'Foundation Date',
                  hintName: 'Select date',
                  readOnly: true,
                  teController: createCommunityController.foundationDateController,
                  onChangedAction: () => createCommunityController.pickFoundationDate(context),
                ),
                SizedBox(width: 12),
                CreateNGOTextField(
                  labelName: 'Community Type',
                  hintName: 'Public',
                ),
                SizedBox(width: 12),
                CreateNGOTextField(
                  labelName: 'Field of Work',
                  hintName: 'Humanity & Socials',
                ),
                SizedBox(width: 12),
                CreateNGOTextField(
                  labelName: 'About',
                  hintName:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interd...',
                  maxOfLine: 4,
                ),
                SizedBox(width: 12),
                CreateNGOTextField(
                  labelName: 'Address',
                  hintName: 'East Santiago Berlin',
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(text: 'Continue', onPressed: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

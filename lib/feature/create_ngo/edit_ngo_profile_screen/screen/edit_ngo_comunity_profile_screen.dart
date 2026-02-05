// edit_ngo_community_profile_screen.dart
// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_profile_screen/widget/create_ngo_text_field.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/change_button.dart';
import 'package:jdadzok/feature/personal_view/widgets/add_profile_picture_button.dart';
import 'package:jdadzok/feature/create_ngo/edit_ngo_profile_screen/controller/edit_ngo_commuity_profile_controller.dart';

// ignore: must_be_immutable
class EditNgoCommunityProfileScreen extends StatelessWidget {

  final EditNgoCommunityProfileController editController = Get.put(EditNgoCommunityProfileController());

  EditNgoCommunityProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {



      return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0XFFEFEFEF),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      editController.isNgo.value ? "Edit NGO" : 'Edit Community',
                      style: globalTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 31),
                Text(
                  editController.isNgo.value ? "NGO Profile" : "Community Profile",
                  style: globalTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                // Cover photo + profile photo stack
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Cover photo
                    Obx(() {
                      final coverFile = editController.coverImage.value;
                      final coverUrl = editController.existingOrg.value?.profile?.coverUrl;
                      ImageProvider imageProvider;
                      if (coverFile != null) {
                        imageProvider = FileImage(coverFile);
                      } else if (coverUrl != null && coverUrl.isNotEmpty) {
                        imageProvider = NetworkImage(coverUrl);
                      } else {
                        imageProvider = AssetImage(ImagePath.ngoCoverImage);
                      }

                      return Container(
                        width: double.infinity,
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      );
                    }),

                    // Change button for cover
                    ChangeButton(
                      onImagePicked: (file) {
                        editController.coverImage.value = file;
                      },
                    ),

                    // profile picture centered
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Profile Image with borders
                            Container(
                              margin: EdgeInsets.only(top: 100), // white border
                              padding: EdgeInsets.all(3), // white border
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(5), // green border
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(3), // inner white padding
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Obx(() {
                                    // highest priority - picked image
                                    if (editController.pickedImage.value != null) {
                                      return CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(editController.pickedImage.value!),
                                      );
                                    }

                                    // second - server avatar
                                    if (editController.existingOrg.value?.profile?.avatarUrl != null) {
                                      return CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          editController.existingOrg.value!.profile!.avatarUrl!,
                                        ),
                                      );
                                    }

                                    // default fallback
                                    return const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(ImagePath.ngoHexaMediaImage),
                                    );
                                  }),
                                ),
                              ),
                            ),

                            // Add profile picture button
                            AddProfilePictureButton(
                              icons: Icons.camera_alt_outlined,
                              text: 'Edit',
                              boxDecoration: BoxDecoration(
                                color: AppColors.iconBackgroundColor,
                                borderRadius: BorderRadius.circular(18),
                                shape: BoxShape.rectangle,
                              ),
                              iconColor: Colors.black,
                              onImagePicked: (file) {
                                editController.pickedImage.value = file;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Form(
                  key: editController.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CreateNGOTextField(
                        teController: editController.communityNameController,
                        labelName: editController.isNgo.value ? "NGO Name" : "Community Name",
                        hintName: "Enter Name",
                      ),
                      CreateNGOTextField(
                        teController: editController.dateController,
                        labelName: "Foundation Date",
                        hintName: "23/01/2025",
                        iconButton: IconButton(
                          onPressed: () {
                            editController.pickDate(context);
                          },
                          icon: Icon(Icons.calendar_today_rounded, color: Colors.blue),
                        ),
                      ),
                      Text('Type', style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0XFF6A6A6A))),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none)),
                          value: editController.communityTypeController.text.isEmpty ? null : editController.communityTypeController.text,
                          hint: const Text("Select Type"),
                          items: [
                            DropdownMenuItem(value: "PUBLIC", child: Text("Public")),
                            DropdownMenuItem(value: "PRIVATE", child: Text("Private")),
                            DropdownMenuItem(value: "CUSTOM", child: Text("Custom")),
                          ],
                          onChanged: (value) {
                            editController.communityTypeController.text = value ?? '';
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      CreateNGOTextField(teController: editController.fieldOfWorkController, labelName: "Field of Work", hintName: "Humanity & Socials"),
                      CreateNGOTextField(teController: editController.aboutController, labelName: "About", hintName: "Lorem ipsum losren", maxOfLine: 4),
                      CreateNGOTextField(teController: editController.addressController, labelName: "Address", hintName: "6391 Elgin St. Celina, Deaware 10299"),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "Update",
                          onPressed: () {
                            _updateButton();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateButton() {
    if (editController.formKey.currentState!.validate()) {
      editController.onClickUpdate();
    }
  }
}

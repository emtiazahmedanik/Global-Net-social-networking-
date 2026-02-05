// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_profile_screen/controller/create_ngo_commuity_profile_controller.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_profile_screen/widget/create_ngo_text_field.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

// ignore: must_be_immutable
class CreateNgoComunityProfileScreen extends StatelessWidget {
  final bool isNgo;
  final OrganizationModel? existingOrg;
  late CreateNgoCommuityProfileController createNgoProfileController;

  CreateNgoComunityProfileScreen({
    Key? key,
    required this.isNgo,
    this.existingOrg,
  }) {
    createNgoProfileController = Get.put(
      CreateNgoCommuityProfileController(isNgo: isNgo),
    );
  }

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
                      isNgo ? "Create NGO" : 'Create Community',
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
                  isNgo ? "NGO Profile" : "Community Profile",
                  style: globalTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  spacing: 9,
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            createNgoProfileController.pickedImage.value != null
                            ? FileImage(
                                createNgoProfileController.pickedImage.value!,
                              )
                            : AssetImage(ImagePath.profileImage009),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //padding: EdgeInsets.all(2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        backgroundColor: AppColors.primaryColor.withValues(
                          alpha: 0.6,
                        ), //Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      onPressed: () {
                        createNgoProfileController.pickImageFromGallery();
                      },
                      child: Text(
                        "Upload Image",
                        style: globalTextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Form(
                  key: createNgoProfileController.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CreateNGOTextField(
                        teController:
                            createNgoProfileController.communityNameController,
                        labelName: isNgo ? "NGO Name" : "Community Name",
                        hintName: "Enter Name",
                      ),
                      //field for date
                      CreateNGOTextField(
                        teController: createNgoProfileController.dateController,
                        labelName: "Foundation Date",
                        hintName: "23/01/2025",
                        iconButton: IconButton(
                          onPressed: () {
                            //icon action here for click calender open
                            createNgoProfileController.pickDate(context);
                          },
                          icon: Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                      Text(
                        'Type',
                        style: globalTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF6A6A6A),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value:
                              createNgoProfileController
                                  .communityTypeController
                                  .text
                                  .isEmpty
                              ? null
                              : createNgoProfileController
                                    .communityTypeController
                                    .text,
                          hint: const Text("Select Type"),
                          items: [
                            DropdownMenuItem(
                              value: "PUBLIC",
                              child: Text("Public"),
                            ),
                            DropdownMenuItem(
                              value: "PRIVATE",
                              child: Text("Private"),
                            ),
                            DropdownMenuItem(
                              value: "CUSTOM",
                              child: Text("Custom"),
                            ),
                          ],
                          onChanged: (value) {
                            createNgoProfileController
                                    .communityTypeController
                                    .text =
                                value!;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      CreateNGOTextField(
                        teController:
                            createNgoProfileController.fieldOfWorkController,
                        labelName: "Field of Work",
                        hintName: "Humanity & Socials",
                      ),
                      CreateNGOTextField(
                        teController:
                            createNgoProfileController.aboutController,
                        labelName: "About",
                        hintName: "Lorem ipsum losren",
                        maxOfLine: 4,
                      ),
                      CreateNGOTextField(
                        teController:
                            createNgoProfileController.addressController,
                        labelName: "Address",
                        hintName: "6391 Elgin St. Celina, Deaware 10299",
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "Create",
                          onPressed: () {
                            // go to ngo profile page
                            _createButton();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createButton() {
    if (createNgoProfileController.formKey.currentState!.validate()) {
      createNgoProfileController.onClickCreate();
      //Get.to(() => CreateNgoVerifyProfileScreen(isNgo: isNgo));
    }
  }
}

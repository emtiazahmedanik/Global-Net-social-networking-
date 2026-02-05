import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/feature/edit_profile/controller/edit_profile_screen_controller.dart';
import 'package:jdadzok/feature/edit_profile/widget/text_field.dart';

// ignore: must_be_immutable
class EditProfileTextForm extends StatelessWidget {
  EditProfileTextForm({super.key});

  EditProfileScreenController editProfileScreenController = Get.find<EditProfileScreenController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: editProfileScreenController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //For First Name
              Text("First Name", style: _textStyle()),
              SizedBox(height: 10),
              editProfileCustomTextField(
                controller: editProfileScreenController.firstNameTEController,
                hintText: "alex",
                fieldType: FieldType.name,
              ),
              SizedBox(height: 20),


              //For Date of Birth
              Text("Date Of Birth", style: _textStyle()),
              SizedBox(height: 10),

              GetBuilder(
                init: editProfileScreenController,
                builder: (_) {
                  return TextFormField(
                    controller: editProfileScreenController.dateController,
                    decoration: InputDecoration(
                      fillColor: AppColors.iconBackgroundColor,
                      filled: true,
                      suffixIcon: Icon(Icons.calendar_today),
                      hintText: "23/11/2025",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    readOnly: true,
                    onTap: () => editProfileScreenController.pickDate(context),
                  );
                },
              ),
              SizedBox(height: 20),

              //For Selected the Gender field
              Text("Gender", style: _textStyle()),
              SizedBox(height: 10),
              GetBuilder(
                init: editProfileScreenController,
                builder: (_) {
                  return DropdownButtonFormField<String>(
                    initialValue: editProfileScreenController.selectedGender,
                    decoration: InputDecoration(
                      fillColor: AppColors.iconBackgroundColor,
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (value) {
                      editProfileScreenController.selectedGender = value!;
                    },
                    items: editProfileScreenController.genders.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(
                          gender,
                          style: TextStyle(
                            color: Color(0XFF6A6A6A),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),

              //For Experience Text Field
              Text("Experience", style: _textStyle()),
              SizedBox(height: 10),
              editProfileCustomTextField(
                controller: editProfileScreenController.experienceTEController,
                hintText: "Marketing Coordinator at SpectraSynq",
                fieldType: FieldType.name,
              ),
              SizedBox(height: 20),

              //For description text field
              Text("Description", style: _textStyle()),
              SizedBox(height: 10),
              editProfileCustomTextField(
                maxline: 6,
                controller: editProfileScreenController.descriptionTEController,
                hintText:
                    " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interd...",
                fieldType: FieldType.name,
              ),
              SizedBox(height: 20),

              //For address text field
              Text("Address", style: _textStyle()),
              SizedBox(height: 10),
              editProfileCustomTextField(
                maxline: 2,
                controller: editProfileScreenController.addressTEController,
                hintText: "6391 Elgin St. Celina, Delaware 10299",
                fieldType: FieldType.name,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle _textStyle() {
  return TextStyle(
    fontFamily: "Inter",
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

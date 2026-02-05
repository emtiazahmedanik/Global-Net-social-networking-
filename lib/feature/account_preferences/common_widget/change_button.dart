import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/controller/filepicker_controller.dart';

class ChangeButton extends StatelessWidget {
  final Function(File)? onImagePicked;

  const ChangeButton({super.key, this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    final ImagePickerController controller = Get.put(ImagePickerController());

    return GestureDetector(
      onTap: () async {
        final File? selectedFile = await controller.pickImageFromGallery(context);
        if (selectedFile != null && onImagePicked != null) {
          onImagePicked!(selectedFile); // 🔥 Pass file back to parent
        }
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.only(top: 100, right: 20),
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 0.5),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.5),
                Color.fromARGB(1, 255, 255, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/change_icon.png',
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

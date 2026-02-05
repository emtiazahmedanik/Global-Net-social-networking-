import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/controller/filepicker_controller.dart';

class AddProfilePictureButton extends StatelessWidget {
  final Function(File)? onImagePicked;
  AddProfilePictureButton({
    super.key,
    required this.icons,
    this.text,
    this.boxDecoration,
    this.iconColor,
    this.isAddStory,
    this.onImagePicked,
  });
  final ImagePickerController controller = Get.put(ImagePickerController());
  final FilePickerController filePickerController = Get.put(
    FilePickerController(),
  );

  final IconData icons;
  final String? text;
  final BoxDecoration? boxDecoration;
  final Color? iconColor;
  final bool? isAddStory;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -2,
      right: 20,
      child: Container(
        decoration: boxDecoration,
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.photo,
                          color: Color(0xff2D55FF),
                        ),
                        title: const Text(
                          'Add profile picture',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          final File? selectedFile = await controller
                              .pickImageFromGallery(context);
                          if (selectedFile != null && onImagePicked != null) {
                            onImagePicked!(selectedFile);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),

                      if (isAddStory == true) ...[
                        ListTile(
                          leading: const Icon(
                            Icons.history,
                            color: Color(0xff2D55FF),
                          ),
                          title: const Text(
                            'Add Story',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            filePickerController.pickFile();
                          },
                        ),
                      ],

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(icons, color: iconColor ?? Colors.white, size: 16),
                if (text != null) ...[SizedBox(width: 3), Text(text!)],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

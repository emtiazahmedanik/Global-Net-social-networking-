// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);

  Future<File?> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = image;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image Selected: ${image.name}"),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
            duration: Duration(seconds: 2),
          ),
        );
        return File(selectedImage.value!.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No image selected"),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
            duration: Duration(seconds: 2),
          ),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }
  }
}

class FilePickerController {
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        PlatformFile file = result.files.single;
        debugPrint(
          'Selected file: ${file.name} (${(file.size / 1024).toStringAsFixed(2)} KB)',
        );
      } else {
        debugPrint('No file selected');
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }
}

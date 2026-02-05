import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/create_ngo/upload%20documents/controller/filepicker_controller.dart';

class UploadBoxWidget extends StatelessWidget {
  const UploadBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final NGOFilePickerController fileController = Get.put(
      NGOFilePickerController(),
    );

    return GestureDetector(
      onTap: () {
        fileController.pickJpgFile();
      },
      child: Container(
        width: double.infinity,
        height: 243,
        alignment: Alignment.center,
        decoration: DottedDecoration(
          shape: Shape.box,
          borderRadius: BorderRadius.circular(12),
          dash: const <int>[6, 4],
          strokeWidth: 2.0,
          color: Colors.grey,
        ),
        child: Obx(() {
          if (fileController.selectedFilePath.isNotEmpty) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(fileController.selectedFilePath.value),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.file_upload, size: 40, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  "Click to upload or drag and drop",
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  "Max 10mb file size, Only jpg file",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

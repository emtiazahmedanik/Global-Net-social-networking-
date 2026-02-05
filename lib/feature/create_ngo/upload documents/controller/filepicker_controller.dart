import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class NGOFilePickerController extends GetxController {
  var selectedFilePath = ''.obs;

  Future<void> pickJpgFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'], // only jpg
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      // Max size 10 MB
      if (await file.length() <= 10 * 1024 * 1024) {
        selectedFilePath.value = file.path;
      } else {
        Get.snackbar("Error", "File size exceeds 10MB limit!");
      }
    }
  }
}

import 'package:flutter/material.dart';

class FilePickerModal extends StatelessWidget {
  final Function(String) onFileTypeSelected;

  const FilePickerModal({super.key, required this.onFileTypeSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select File Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Photos'),
            onTap: () {
              Navigator.pop(context);
              onFileTypeSelected('Photo selected');
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.insert_drive_file),
          //   title: const Text('Documents'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     onFileTypeSelected('Document selected');
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.video_library),
          //   title: const Text('Videos'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     onFileTypeSelected('Video selected');
          //   },
          // ),
        ],
      ),
    );
  }
}

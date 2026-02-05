import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/chat/chat%20more%20option/shared%20photos/widgets/old_photos_widget.dart';
import 'package:jdadzok/feature/chat/chat%20more%20option/shared%20photos/widgets/today_photos_widgets.dart';

class SharedPhotosScreen extends StatelessWidget {
  const SharedPhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Shared Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 25),

              Text(
                'Today',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              TodayPhotosWidgets(),
              SizedBox(height: 16),
              Text(
                'Old Photos',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),

              OldPhotosWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

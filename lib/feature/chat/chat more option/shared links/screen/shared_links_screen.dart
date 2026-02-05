import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/chat/chat%20more%20option/shared%20links/widgets/links_widget.dart';

class SharedLinksScreen extends StatelessWidget {
  const SharedLinksScreen({super.key});

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
                        'Shared Links',
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
              SizedBox(height: 12),
              LinksWidget(
                imageUrl:
                    'https://www.carpro.com/hs-fs/hubfs/2023-Chevrolet-Corvette-Z06-credit-chevrolet.jpeg?width=1020&name=2023-Chevrolet-Corvette-Z06-credit-chevrolet.jpeg',
                link:
                    'https://www.carpro.com/hs-fs/hubfs/2023-Chevrolet-Corvette-Z06-credit-chevrolet.jpeg?width=1020&name=2023-Chevrolet-Corvette-Z06-credit-chevrolet.jpeg',
              ),
              LinksWidget(
                imageUrl:
                    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                link:
                    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ),

              SizedBox(height: 16),
              Text(
                'Old Links',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 12),

              LinksWidget(
                imageUrl: 'https://static.toiimg.com/photo/80387978.cms',
                link: 'https://static.toiimg.com/photo/80387978.cms',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

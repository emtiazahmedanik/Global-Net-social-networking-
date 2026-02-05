import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/create_ngo/identity%20verification/widgets/identity_card_widget.dart';

class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Verifications",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Identity Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'This step helps us verify your identity. Choose the method that works best for you,',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFF6A6A6A),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32),
              IdentityCardWidget(
                title: "Government issued ID/Passport",
                subtitle: "A photo of your government issued ID",
              ),
              SizedBox(height: 16),
              IdentityCardWidget(
                title: "Business Certified/License",
                subtitle:
                    "A photo/documents of your government issued business certificates",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

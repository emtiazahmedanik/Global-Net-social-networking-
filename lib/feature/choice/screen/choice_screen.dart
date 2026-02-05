import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/route/app_route.dart';
import '../../../core/const/app_colors.dart';
import '../contoller/choice_controller.dart';

class ChoiceScreen extends StatelessWidget {
  ChoiceScreen({super.key});

  final ChoiceController controller = Get.put(ChoiceController());

  final List<String> interests = [
    "🎬 Entertainment & Pop Culture",
    "🔬 Science & Tech",
    "🧠 Health & Wellbeing",
    "💼 Work & Careers",
    "📚 Learning & Education",
    "📰 News & Society",
    "🎨 Creative Expression",
    "🛒 Market & Monetize",
    "🌍 Lifestyle & Identity",
    "💞 Relationships & Growth",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Make your choice",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Get better experience",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),

              // Interest Chips
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: interests.map((item) {
                    final isSelected = controller.selectedInterests.contains(
                      item,
                    );
                    return GestureDetector(
                      onTap: () => controller.toggleInterest(item),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.greyColor,
                          ),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Continue",
                  onPressed: () {
                    Get.offAllNamed(AppRoute.bottomNavbar);
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
 
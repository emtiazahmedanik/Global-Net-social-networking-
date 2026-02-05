import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/welcome/controller/welcome_controller.dart';
import 'package:jdadzok/feature/welcome/widget/white_gradient_overlay_widget.dart';
import '../../../core/global_widegts/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final WelcomeController controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: Get.height,
              viewportFraction: 1.0,
              autoPlay: true,
              onPageChanged: controller.onPageChanged,
            ),
            items: controller.sliderImages.map((imagePath) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(imagePath, fit: BoxFit.cover),
                  WhiteGradientOverlayWidget(),
                ],
              );
            }).toList(),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Spacer(),
                Text(
                  "Connect. Express. Belong",
                  style: globalTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  '"Your voice. Your people. One powerful platform. Will serve you everything"',
                  style: globalTextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16),

                // ⚪ Dot Indicator
                Obx(
                  () => DotsIndicator(
                    dotsCount: controller.sliderImages.length,
                    position: controller.currentIndex.value.toDouble(),
                    decorator: DotsDecorator(
                      activeColor: AppColors.primaryColor,
                      size: Size.square(8.0),
                      activeSize: Size(18.0, 8.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // 🔘 Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Get Started",
                    onPressed: controller.onGetStarted,
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

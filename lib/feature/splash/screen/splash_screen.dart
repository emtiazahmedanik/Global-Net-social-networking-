import 'package:flutter/material.dart';
import 'package:get/get.dart';
// optional if using custom AppColors
import 'package:jdadzok/core/const/icons_path.dart';
import '../controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashScreenController controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Image.asset(
                IconsPath.appIcon,
                width: size.width * 0.3,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              // App name: SYNQULAN
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  children: const [
                    TextSpan(
                      text: 'SYNQ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 44,
                      ),
                    ),
                    TextSpan(
                      text: 'ULAN',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 44,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

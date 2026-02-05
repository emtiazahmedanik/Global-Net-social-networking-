import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:get/get.dart';
import 'package:jdadzok/core/stripe/stripe_service.dart';
import 'package:jdadzok/feature/notification/controller/notification_controller.dart';
import 'package:jdadzok/feature/notification/service/notificatioin_socket_service.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';
import 'package:jdadzok/feature/real_time_calling/controller/call_controller.dart';
import 'package:jdadzok/feature/real_time_calling/service/call_service.dart';
import 'package:jdadzok/feature/real_time_calling/service/webrtc_service.dart';
import 'package:jdadzok/route/app_route.dart' show AppRoute;
import 'package:jdadzok/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StripeService.init();
  await initServices();

  configEasyLoading();
  runApp(MyApp());
}

void configEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.blueAccent.shade400
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..maskColor = Colors.green
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'jdadzok',
        getPages: AppRoute.routes,
        initialRoute: AppRoute.splashScreen,
        builder: EasyLoading.init(),
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.light,
      ),
    );
  }
}

Future<void> initServices() async {

  Get.put(AllNotificationController(), permanent: true);
  
  Get.put(SocketService(), permanent: true);
  Get.put(CallService(), permanent: true);
  Get.put(WebRTCService(), permanent: true);
  Get.put(PersonalProfileViewController());
  
  await Get.find<SocketService>().init();
  await Get.find<CallService>().init();
  await Get.find<WebRTCService>().init();
  
  Get.put(CallController(), permanent: true);
  

  

  // Initialize other services if needed
}
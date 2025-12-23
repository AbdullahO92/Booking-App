//import 'package:cozy_app/modules/auth/complete_profile.dart';
import 'package:cozy_app/OnboardingScreens/onboarding.dart';
import 'package:cozy_app/controllers/auth_controller.dart' show AuthController;
import 'package:cozy_app/controllers/bokking_controller.dart';
import 'package:cozy_app/controllers/favorites_controller.dart';
import 'package:cozy_app/controllers/owner_apartments_controller.dart';
import 'package:cozy_app/modules/auth/login_page.dart';
import 'package:cozy_app/modules/auth/register_page.dart';
import 'package:cozy_app/modules/home/home_page.dart';
import 'package:cozy_app/modules/home/main_page.dart';
import 'package:cozy_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart' show GetMaterialApp;
import 'package:get/get_navigation/src/routes/get_route.dart';

void main() {
  Get.put(BookingController());
  Get.put(AuthController()); // إذا لم يكن مسجّل مسبقًا
  Get.put(FavoritesController());
 Get.put(OwnerApartmentsController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
 initialRoute: AppRoutes.OnBoardingBody,
  getPages: [
     GetPage(name: AppRoutes.OnBoardingBody, page: () => OnBoardingScreen()),
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.registration, page: () => RegisterPage()),
    GetPage(name: AppRoutes.homePage, page: () => HomePage()),
 GetPage(name: AppRoutes.mainPage, page: () => const MainPage()),
  ],
);
}
}
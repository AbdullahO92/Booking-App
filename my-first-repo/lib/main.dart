import 'package:cozy_app/controllers/auth_controller.dart';
import 'package:cozy_app/OnboardingScreens/onboarding.dart';
import 'package:cozy_app/modules/auth/login_page.dart';
import 'package:cozy_app/modules/auth/register_page.dart';
import 'package:cozy_app/modules/home/home_page.dart';
import 'package:cozy_app/modules/home/main_page.dart';
import 'package:cozy_app/modules/admin/admin_dashboard.dart';
import 'package:cozy_app/modules/admin/approve_users_page.dart';
import 'package:cozy_app/modules/admin/approve_apartments_page.dart';
import 'package:cozy_app/routes/app_bindings.dart';
import 'package:cozy_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  AppBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    // تحديد الصفحة الأولى حسب حالة تسجيل الدخول ونوع المستخدم
    String initialRoute;
    if (authController.token.value.isNotEmpty) {
      if (authController.currentUser.value?.role == 'admin') {
        initialRoute = AppRoutes.adminDashboard;
      } else {
        initialRoute = AppRoutes.mainPage;
      }
    } else {
      initialRoute = AppRoutes.OnBoardingBody;
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cozy App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Cairo',
      ),
      initialRoute: initialRoute,
      getPages: [
        // Auth Routes
        GetPage(name: AppRoutes.OnBoardingBody, page: () => OnBoardingScreen()),
        GetPage(name: AppRoutes.login, page: () => LoginPage()),
        GetPage(name: AppRoutes.registration, page: () => RegisterPage()),

        // Main Routes
        GetPage(name: AppRoutes.homePage, page: () => HomePage()),
        GetPage(name: AppRoutes.mainPage, page: () => const MainPage()),

        // Admin Routes
        GetPage(name: AppRoutes.adminDashboard, page: () => const AdminDashboard()),
        GetPage(name: AppRoutes.approveUsers, page: () => const ApproveUsersPage()),
        GetPage(name: AppRoutes.approveApartments, page: () => const ApproveApartmentsPage()),
      ],
    );
  }
}
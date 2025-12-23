import 'dart:io';

import 'package:cozy_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

enum UserType { renter, owner }

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // LOGIN
  TextEditingController loginPhoneController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  // REGISTER
  TextEditingController regPhoneController = TextEditingController();
  TextEditingController regPasswordController = TextEditingController();
  TextEditingController regFirstNameController = TextEditingController();
  TextEditingController regLastNameController = TextEditingController();
  TextEditingController regBirthdayController = TextEditingController();

  Rx<File?> profileImage = Rx<File?>(null);
  Rx<File?> idImage = Rx<File?>(null);

  UserType userType = UserType.renter;

  RxBool isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxString token = "".obs;
RxBool regPasswordVisible = true.obs;

  get tempUser => null;
  void setUser(UserType type) {
    userType = type;
    update();
  }

  //  LOGIN
  Future<void> login() async {
    try {
      isLoading.value = true;

      final res = await _authService.login(
        phone: loginPhoneController.text.trim(),
        password: loginPasswordController.text.trim(),
      );

      currentUser.value = res.user;
      token.value = res.token;

      Get.offAllNamed(AppRoutes.mainPage);
    } catch (_) {
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة");
    } finally {
      isLoading.value = false;
    }
  }

  //  REGISTER
  Future<void> register() async {
    if (profileImage.value == null || idImage.value == null) {
      Get.snackbar("خطأ", "الصور مطلوبة");
      return;
    }

    try {
      isLoading.value = true;

      final res = await _authService.register(
        phone: regPhoneController.text.trim(),
        password: regPasswordController.text.trim(),
        firstName: regFirstNameController.text.trim(),
        lastName: regLastNameController.text.trim(),
        birthDate: regBirthdayController.text.trim(),
        role: userType == UserType.owner ? "owner" : "tenant",
        userImage: profileImage.value!,
        idImage: idImage.value!,
      );

      currentUser.value = res.user;

      Get.snackbar("نجاح", res.message);
      Get.offAllNamed(AppRoutes.login);
    } catch (_) {
      Get.snackbar("خطأ", "فشل إنشاء الحساب");
    } finally {
      isLoading.value = false;
    }
  }
}

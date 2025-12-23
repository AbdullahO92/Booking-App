import 'dart:io';
import 'package:cozy_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  // Profile Image
  Future<void> pickProfileImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      authController.profileImage.value = File(picked.path);
    }
  }

  // ID Image
  Future<void> pickIdImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      authController.idImage.value = File(picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 248, 247),
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),

              // Profile Image
              Obx(() {
                return GestureDetector(
                  onTap: pickProfileImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: authController.profileImage.value != null
                        ? FileImage(authController.profileImage.value!)
                        : null,
                    child: authController.profileImage.value == null
                        ? const Icon(Icons.camera_alt,
                            size: 35, color: Colors.black54)
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 20),

              // PHONE
              TextFormField(
                controller: authController.regPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  filled: true,
                  fillColor: Color.fromARGB(118, 212, 214, 188),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "هذا الحقل مطلوب";
                  }
                  if (value.length != 10) {
                    return "الرقم يجب أن يكون 10 خانات";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // PASSWORD
              Obx(() => TextFormField(
                    controller: authController.regPasswordController,
                    obscureText: authController.regPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: const Color.fromARGB(118, 212, 214, 188),
                      suffixIcon: IconButton(
                        icon: Icon(authController.regPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => authController.regPasswordVisible.value =
                            !authController.regPasswordVisible.value,
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "الحقل مطلوب" : null,
                  )),
              const SizedBox(height: 10),

              // FIRST NAME
              TextFormField(
                controller: authController.regFirstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Color.fromARGB(118, 212, 214, 188),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "الحقل مطلوب" : null,
              ),
              const SizedBox(height: 10),

              // LAST NAME
              TextFormField(
                controller: authController.regLastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  prefixIcon: Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Color.fromARGB(118, 212, 214, 188),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "الحقل مطلوب" : null,
              ),
              const SizedBox(height: 10),

             
              TextFormField(
                controller: authController.regBirthdayController,
                decoration: const InputDecoration(
                  labelText: "Birthday (YYYY-MM-DD)",
                  prefixIcon: Icon(Icons.date_range),
                  filled: true,
                  fillColor: Color.fromARGB(118, 212, 214, 188),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "الحقل مطلوب" : null,
              ),
              const SizedBox(height: 20),

              
              Row(
                children: [
                  const Icon(Icons.credit_card, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                          onPressed: pickIdImage,
                          child: Text(
                            authController.idImage.value == null
                                ? "Upload ID Image"
                                : "ID Image Selected",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 26, 107, 81)),
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 25),

           
              GetBuilder<AuthController>(
                builder: (controller) {
                  return Column(
                    children: [
                      ListTile(
                        title: const Text("Tenant"),
                        leading: Radio<UserType>(
                          value: UserType.renter,
                          groupValue: controller.userType,
                          onChanged: (value) {
                            if (value != null) controller.setUser(value);
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("Owner"),
                        leading: Radio<UserType>(
                          value: UserType.owner,
                          groupValue: controller.userType,
                          onChanged: (value) {
                            if (value != null) controller.setUser(value);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

             
              Obx(() => authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            authController.register();
                          }
                        },
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                              color: Color.fromARGB(255, 26, 107, 81)),
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

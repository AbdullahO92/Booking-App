import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cozy_app/controllers/owner_apartments_controller.dart';
import 'package:cozy_app/modules/home/apartment_model.dart';

class MyApartmentsPage extends StatelessWidget {
  MyApartmentsPage({super.key});

  final ownerController = Get.find<OwnerApartmentsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("شُقَقي"),
        centerTitle: true,
      ),

      body: Obx(() {
        if (ownerController.myApartments.isEmpty) {
          return const Center(
            child: Text(
              "لم تقم بإضافة أي شقة بعد",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: ownerController.myApartments.length,
          itemBuilder: (context, index) {
            Apartment a = ownerController.myApartments[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // صورة الشقة
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: 
                    // Image.asset(
                    //   a.image,
                    //   width: 120,
                    //   height: 120,
                    //   fit: BoxFit.cover,
                    // ),
                    a.image.startsWith("C:") || a.image.startsWith("/")
    ? Image.file(
        File(a.image),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      )
    : Image.asset(
        a.image,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      )

                  ),

                  const SizedBox(width: 10),

                  // تفاصيل الشقة
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),

                          Text("${a.price} \$ لليوم",
                              style: const TextStyle(fontSize: 15)),

                          const SizedBox(height: 4),

                          Text("${a.rooms} غرف",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),

                          const SizedBox(height: 4),

                          Text("${a.governorate} - ${a.city}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // TODO: صفحة تعديل الشقة
                          Get.snackbar("قريبًا", "سيتم إضافة صفحة التعديل.");
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ownerController.deleteApartment(a.id);
                          Get.snackbar("تم الحذف", "تم حذف الشقة بنجاح");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

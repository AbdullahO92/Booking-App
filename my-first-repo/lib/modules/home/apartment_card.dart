import 'dart:io';

import 'package:cozy_app/controllers/favorites_controller.dart' show FavoritesController;
import 'package:cozy_app/modules/home/apartment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onTap;

   ApartmentCard({super.key, required this.apartment, required this.onTap});

 final favController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                  
Stack(
  children: [
    ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: apartment.image.startsWith("C:") ||
              apartment.image.startsWith("/") ||
              apartment.image.contains("\\")
          ? Image.file(
              File(apartment.image),
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Image.asset(
              apartment.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
    ),

  // زر المفضلة
  Positioned(
                    right: 12,
                    top: 12,
                    child: Obx(() {
                      bool fav = favController.isFavorite(apartment);
    
                      return GestureDetector(
                        onTap: () => favController.toggleFavorite(apartment),
                        child: Icon(
                          fav ? Icons.favorite : Icons.favorite_border,
                          color: fav ? Colors.red : Colors.white,
                          size: 30,
                        ),
        );
      }),
    ),
  ],
),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم الشقة
                  Text(
                    apartment.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                     // السعر
                    "\$${apartment.price} / night",
                    style: const TextStyle(
                        fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed:
                  //    onTap,
                  //   child: const Text("Book Now"),
                  // ),
                     // السعر
Row(
                    children: [
                      if (apartment.location != null) ...[
                        const Icon(Icons.location_on, size: 18, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          apartment.location!,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(width: 15),
                      ],

                    
                        const Icon(Icons.meeting_room, size: 18, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${apartment.rooms} rooms",
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      
                    ],
                  ),

                  const SizedBox(height: 10),

                  // زر الذهاب لصفحة التفاصيل
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                       onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(fontSize: 16),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
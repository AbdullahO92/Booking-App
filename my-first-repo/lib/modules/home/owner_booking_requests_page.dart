import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cozy_app/controllers/owner_apartments_controller.dart';

class OwnerBookingRequestsPage extends StatefulWidget {
  const OwnerBookingRequestsPage({super.key});

  @override
  State<OwnerBookingRequestsPage> createState() => _OwnerBookingRequestsPageState();
}

class _OwnerBookingRequestsPageState extends State<OwnerBookingRequestsPage> {
  final ownerController = Get.find<OwnerApartmentsController>();

  @override
  void initState() {
    super.initState();
    ownerController.fetchPendingBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات الحجز"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Obx(() {
        if (ownerController.isLoadingBookings.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        if (ownerController.pendingBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  "لا توجد طلبات حجز جديدة",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ownerController.fetchPendingBookings(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: ownerController.pendingBookings.length,
            itemBuilder: (context, index) {
              final booking = ownerController.pendingBookings[index];
              return _buildBookingCard(booking);
            },
          ),
        );
      }),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final user = booking['user'] ?? {};
    final apartment = booking['apartment'] ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الشقة
            Row(
              children: [
                const Icon(Icons.apartment, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    apartment['title'] ?? 'شقة',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),

            // معلومات المستأجر
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: const Icon(Icons.person, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user['phone'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // تواريخ الحجز
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("من", style: TextStyle(color: Colors.grey)),
                      Text(
                        booking['from'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.teal),
                  Column(
                    children: [
                      const Text("إلى", style: TextStyle(color: Colors.grey)),
                      Text(
                        booking['to'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // أزرار القبول والرفض
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveBooking(booking['id']),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text("قبول", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rejectBooking(booking['id']),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text("رفض", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _approveBooking(int bookingId) {
    Get.defaultDialog(
      title: "تأكيد القبول",
      middleText: "هل تريد قبول هذا الحجز؟",
      textConfirm: "قبول",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () async {
        Get.back();
        try {
          await ownerController.approveBooking(bookingId);
          Get.snackbar("تم", "تم قبول الحجز بنجاح",
              backgroundColor: Colors.green, colorText: Colors.white);
        } catch (e) {
          Get.snackbar("خطأ", e.toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
    );
  }

  void _rejectBooking(int bookingId) {
    Get.defaultDialog(
      title: "تأكيد الرفض",
      middleText: "هل تريد رفض هذا الحجز؟",
      textConfirm: "رفض",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          await ownerController.rejectBooking(bookingId);
          Get.snackbar("تم", "تم رفض الحجز",
              backgroundColor: Colors.orange, colorText: Colors.white);
        } catch (e) {
          Get.snackbar("خطأ", e.toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
    );
  }
}
import 'package:cozy_app/controllers/bokking_controller.dart';
import 'package:cozy_app/modules/booking/booking_details_page.dart';
import 'package:cozy_app/modules/home/apartment_model.dart';
import 'package:cozy_app/modules/home/dummy_apartments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../data/models/booking.dart';

//عرض الحجوزات التي تم إنشاؤها
class MyBookingsPage extends StatelessWidget {
  MyBookingsPage({super.key});
  final BookingController bookingController = Get.find();
  final AuthController authController = Get.find();
  final List<Apartment> apartments = dummyApartments;

  @override
  Widget build(BuildContext context) {
    final phone = authController.tempUser.phone ?? 'unknown';
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        final userBookings = bookingController.getUserBookings(phone);
        if (userBookings.isEmpty) {
          return const Center(child: Text('No bookings yet'));
        }
        return ListView.builder(
          itemCount: userBookings.length,
          itemBuilder: (context, index) {
            final Booking b = userBookings[index];
            return ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text(b.apartmentName),
              subtitle: Text(
                '${b.fromDate.toLocal().toString().split(' ')[0]} → ${b.toDate.toLocal().toString().split(' ')[0]}\nGuests: ${b.guests}',
              ),
              trailing: Text('\$${b.totalPrice.toStringAsFixed(2)}'),
              isThreeLine: true,
              // onLongPress: () {
              //   // إلغاء الحجز
              //   Get.defaultDialog(
              //     title: 'Cancel booking',
              //     middleText: 'Do you want to cancel this booking?',
              //     onConfirm: () {
              //       bookingController.cancelBooking(b.id);
              //       Get.back();
              //       Get.snackbar('Cancelled', 'Booking cancelled', backgroundColor: Colors.red, colorText: Colors.white);
              //     },
              //     onCancel: () => Get.back(),    );},
              onTap: () {
                final apt = apartments.firstWhere((a) => a.id == b.apartmentId);

                Get.to(() => BookingDetailsPage(booking: b, apartment: apt));
              },
            );
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cozy_app/controllers/bokking_controller.dart';
import 'package:cozy_app/data/models/booking.dart';
import 'package:cozy_app/modules/booking/my_bookings_page.dart';

import '../../controllers/auth_controller.dart';
import '../../modules/home/apartment_model.dart';

/// صفحة الحجز (جديد أو تعديل)
class BookingPage extends StatefulWidget {
  final Apartment apartment;
  final Booking? oldBooking;

  const BookingPage({
    Key? key,
    required this.apartment,
    this.oldBooking,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final BookingController bookingController = Get.put(BookingController());
  final AuthController authController = Get.find();

  DateTime? fromDate;
  DateTime? toDate;
  int guests = 1;

  @override
  void initState() {
    super.initState();
    
    if (widget.oldBooking != null) {
      fromDate = widget.oldBooking!.fromDate;
      toDate = widget.oldBooking!.toDate;
      guests = widget.oldBooking!.guests;
    }
  }

  Future<void> pickFromDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => fromDate = picked);
  }

  Future<void> pickToDate() async {
    final start = fromDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? start.add(const Duration(days: 1)),
      firstDate: start.add(const Duration(days: 1)),
      lastDate: DateTime(start.year + 2),
    );
    if (picked != null) setState(() => toDate = picked);
  }

  int getNights() {
    if (fromDate == null || toDate == null) return 0;
    final diff = toDate!.difference(fromDate!).inDays;
    return diff > 0 ? diff : 0;
  }

  double getTotal() {
    final nights = getNights();
    final pricePerNight = widget.apartment.price.toDouble();
    return (nights > 0 ? nights : 1) * pricePerNight;
  }

  void handleBookNow() {
    if (fromDate == null || toDate == null) {
      Get.snackbar('خطأ', 'اختر تاريخ الوصول والمغادرة',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (toDate!.isBefore(fromDate!)) {
      Get.snackbar('خطأ', 'تاريخ المغادرة يجب أن يكون بعد الوصول',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (widget.oldBooking != null) {
     
      bookingController.cancelBooking(widget.oldBooking!.id);
    }

    bookingController.createBooking(
      apartment: widget.apartment,
      from: fromDate!,
      to: toDate!,
      guests: guests,
    );

    Get.snackbar('تم', widget.oldBooking != null ? 'تم تعديل الحجز بنجاح' : 'تم إنشاء الحجز بنجاح',
        backgroundColor: Colors.green, colorText: Colors.white);

  
    Get.off(() => MyBookingsPage());
  }

  void handleCancelBooking() {
    if (widget.oldBooking != null) {
      bookingController.cancelBooking(widget.oldBooking!.id);
      Get.snackbar('تم', 'تم إلغاء الحجز', backgroundColor: Colors.red, colorText: Colors.white);
      Get.off(() => MyBookingsPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.apartment;
    return Scaffold(
      appBar: AppBar(title: Text(widget.oldBooking != null ? 'Edit Booking - ${apt.name}' : 'Book - ${apt.name}'), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                apt.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(apt.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('\$${apt.price} per night', style: const TextStyle(fontSize: 16, color: Colors.green)),
            const SizedBox(height: 6),
            if (apt.ownerPhone != null)
              Text('Owner: ${apt.ownerPhone}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 20),

            // FROM date
            Text('From', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: pickFromDate,
                    child: Text(fromDate == null ? 'Choose arrival date' : fromDate!.toLocal().toString().split(' ')[0]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

           
            Text('To', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: pickToDate,
                    child: Text(toDate == null ? 'Choose departure date' : toDate!.toLocal().toString().split(' ')[0]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

         
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Guests', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() { if (guests > 1) guests--; }),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$guests'),
                    IconButton(
                      onPressed: () => setState(() { guests++; }),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

       
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Nights: ${getNights()}'),
                  const SizedBox(height: 6),
                  Text('Price per night: \$${apt.price}'),
                  const SizedBox(height: 6),
                  Text('Total: \$${getTotal().toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
            const SizedBox(height: 20),

          
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: handleBookNow,
                    child: Text(widget.oldBooking != null ? 'Update Booking' : 'Book Now', style: const TextStyle(fontSize: 18)),
                  ),
                ),
                if (widget.oldBooking != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: handleCancelBooking,
                      child: const Text('Cancel', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

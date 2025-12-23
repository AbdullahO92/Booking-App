import 'package:get/get.dart';
import 'package:cozy_app/data/models/booking.dart';
import 'package:cozy_app/modules/home/apartment_model.dart'; // أو مسار الموديل عندك
import 'auth_controller.dart';

class BookingController extends GetxController {
  final RxList<Booking> bookings = <Booking>[].obs;

  int _nextId = 1;

  // احفظ حجز محلياً (لاحقًا تستبدل باستدعاء API)
  void createBooking({
    required Apartment apartment,
    required DateTime from,
    required DateTime to,
    required int guests,
  }) {
    final nights = to.difference(from).inDays;
    final effectiveNights = nights > 0 ? nights : 1;
    final pricePerNight = apartment.price.toDouble();
    final total = pricePerNight * effectiveNights;

    final auth = Get.find<AuthController>();
    final userPhone = auth.tempUser?.phone ?? 'unknown';

    final booking = Booking(
      id: _nextId++,
      apartmentId: apartment.id,
      apartmentName: apartment.name,
      userPhone: userPhone,
      fromDate: from,
      toDate: to,
      guests: guests,
      pricePerNight: pricePerNight,
      totalPrice: total,
    );

    bookings.add(booking);
    update();
  }

  List<Booking> getUserBookings(String phone) {
    return bookings.where((b) => b.userPhone == phone).toList();
  }

  void cancelBooking(int bookingId) {
    bookings.removeWhere((b) => b.id == bookingId);
    update();
  }
}

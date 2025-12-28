import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class OwnerService {
  static String get baseUrl {
    if (kIsWeb) return "http://127.0.0.1:8000/api";
    if (Platform.isAndroid) return "http://10.0.2.2:8000/api";
    return "http://127.0.0.1:8000/api";
  }

  /// جلب شقق المالك
  Future<List<dynamic>> getMyApartments(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/my_apartment"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('data')) {
        return data['data'];
      }
      return data is List ? data : [];
    } else {
      throw Exception("فشل جلب الشقق");
    }
  }

  /// إنشاء شقة جديدة
  Future<void> createApartment({
    required String token,
    required String title,
    required String description,
    required double pricePerDay,
    required int rooms,
    required int area,
    required int governorateId,
    required int cityId,
    required List<Uint8List> images,
    required int mainImageIndex,
  }) async {
    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/apartment"));
    request.headers["Accept"] = "application/json";
    request.headers["Authorization"] = "Bearer $token";

    request.fields.addAll({
      "title": title,
      "description": description,
      "price_per_day": pricePerDay.toString(),
      "rooms": rooms.toString(),
      "area": area.toString(),
      "governorate_id": governorateId.toString(),
      "city_id": cityId.toString(),
      "main_image_index": mainImageIndex.toString(),
    });

    for (int i = 0; i < images.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        "images[]",
        images[i],
        filename: "image_$i.jpg",
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = jsonDecode(responseBody);
      throw Exception(body['cause'] ?? body['message'] ?? "فشل إنشاء الشقة");
    }
  }

  /// تحديث شقة
  Future<void> updateApartment({
    required String token,
    required int apartmentId,
    required String title,
    required String description,
    required double pricePerDay,
    required int rooms,
    required int area,
    required int governorateId,
    required int cityId,
    List<Uint8List>? images,
    int mainImageIndex = 0,
  }) async {
    // إذا كانت هناك صور جديدة، نستخدم multipart request
    if (images != null && images.isNotEmpty) {
      final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/apartment/$apartmentId"));
      request.headers["Accept"] = "application/json";
      request.headers["Authorization"] = "Bearer $token";

      // Laravel يتطلب _method لـ PUT في multipart
      request.fields["_method"] = "PUT";
      request.fields["title"] = title;
      request.fields["description"] = description;
      request.fields["price_per_day"] = pricePerDay.toString();
      request.fields["rooms"] = rooms.toString();
      request.fields["area"] = area.toString();
      request.fields["governorate_id"] = governorateId.toString();
      request.fields["city_id"] = cityId.toString();
      request.fields["main_image_index"] = mainImageIndex.toString();

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
          "images[]",
          images[i],
          filename: "image_$i.jpg",
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        final body = jsonDecode(responseBody);
        throw Exception(body['cause'] ?? body['message'] ?? "فشل تحديث الشقة");
      }
    } else {
      // تحديث بدون صور جديدة
      final response = await http.put(
        Uri.parse("$baseUrl/apartment/$apartmentId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "price_per_day": pricePerDay,
          "rooms": rooms,
          "area": area,
          "governorate_id": governorateId,
          "city_id": cityId,
        }),
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception(body['cause'] ?? body['message'] ?? "فشل تحديث الشقة");
      }
    }
  }

  /// حذف شقة
  Future<void> deleteApartment(String token, int apartmentId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/apartment/$apartmentId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("فشل حذف الشقة");
    }
  }

  /// جلب طلبات الحجز المعلقة
  Future<List<dynamic>> getPendingBookings(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/owner/bookings/pending"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("فشل جلب طلبات الحجز");
    }
  }

  /// قبول حجز
  Future<void> approveBooking(String token, int bookingId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/owner/bookings/$bookingId/approve"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? "فشل قبول الحجز");
    }
  }

  /// رفض حجز
  Future<void> rejectBooking(String token, int bookingId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/owner/bookings/$bookingId/reject"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? "فشل رفض الحجز");
    }
  }
}
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cozy_app/models/auth_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import '../models/register_response_model.dart';

class AuthService {
  //static const String baseUrl = "http://192.168.90.3:8000/api";
  static String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:8000/api";
    }

    if (Platform.isAndroid) {
      return "http://10.0.2.2:8000/api";
    }

    return "http://127.0.0.1:8000/api";
  }

  Map<String, dynamic> _tryDecodeJson(String body, String? contentType) {
    final isJson = contentType != null && contentType.contains("application/json");
    if (!isJson || body.isEmpty) {
      return <String, dynamic>{};
    }
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  String? _extractErrorMessage(Map<String, dynamic> bodyJson) {
    final directMessage = bodyJson['cause'] ?? bodyJson['message'] ?? bodyJson['error'];
    if (directMessage is String && directMessage.isNotEmpty) {
      return directMessage;
    }
    final errors = bodyJson['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      if (firstError is String && firstError.isNotEmpty) {
        return firstError;
      }
    }
    return null;
  }


  //  LOGIN
  Future<LoginResponseModel> login({
    required String phone,
    required String password,
  }) async {
    final response = await
    http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Accept": "application/json"},
      body: {
        "phone": phone,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Login failed");
    }
  }

  //  REGISTER
  Future<RegisterResponseModel> register({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    required String birthDate,
    required String role,
    File? userImage,
    File? idImage,
    Uint8List? userImageBytes,
    Uint8List? idImageBytes,
  }) async {
    final request =
    http.MultipartRequest("POST", Uri.parse("$baseUrl/register"));
    request.headers["Accept"] = "application/json";

    request.fields.addAll({
      "phone": phone,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "birth_date": birthDate,
      "role": role,
    });

    debugPrint("=== Register Debug ===");
    debugPrint("kIsWeb: $kIsWeb");
    debugPrint("userImageBytes: ${userImageBytes != null ? '${userImageBytes.length} bytes' : 'null'}");
    debugPrint("idImageBytes: ${idImageBytes != null ? '${idImageBytes.length} bytes' : 'null'}");
    debugPrint("userImage: ${userImage?.path ?? 'null'}");
    debugPrint("idImage: ${idImage?.path ?? 'null'}");

    if (kIsWeb) {
      if (userImageBytes != null) {
        debugPrint("Adding user_image bytes to request");
        request.files.add(http.MultipartFile.fromBytes(
          "user_image",
          userImageBytes,
          filename: "user_image.jpg",
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      if (idImageBytes != null) {
        debugPrint("Adding id_image bytes to request");
        request.files.add(http.MultipartFile.fromBytes(
          "id_image",
          idImageBytes,
          filename: "id_image.jpg",
          contentType: MediaType('image', 'jpeg'),
        ));
      }
    } else {
      if (userImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath("user_image", userImage.path));
      }
      if (idImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath("id_image", idImage.path));
      }
    }

    debugPrint("Total files in request: ${request.files.length}");
    debugPrint("Fields: ${request.fields}");

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    debugPrint("Response status: ${response.statusCode}");
    debugPrint("Response body: $responseBody");

    final bodyJson =
    _tryDecodeJson(responseBody, response.headers["content-type"]);

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (bodyJson['user'] != null) {
        return RegisterResponseModel.fromJson(bodyJson);
      }

      final cause = _extractErrorMessage(bodyJson);
      throw Exception(cause ?? "Register failed");
    }

    final cause = _extractErrorMessage(bodyJson);
    if (cause != null) {
      throw Exception(cause);
    }
    if (responseBody.isNotEmpty && responseBody.trim().startsWith("<")) {
      throw Exception("Server error (non-JSON response)");
    }
    throw Exception("Register failed");
  }
}
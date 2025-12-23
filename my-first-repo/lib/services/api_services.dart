import 'dart:convert';
import 'dart:io';
import 'package:cozy_app/models/auth_response_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../models/register_response_model.dart';

class AuthService {
 static const String baseUrl = "http://192.168.90.3:8000/api";


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
    required File userImage,
    required File idImage,
  }) async {
    final request =
        http.MultipartRequest("POST", Uri.parse("$baseUrl/register"));

    request.fields.addAll({
      "phone": phone,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "birth_date": birthDate,
      "role": role,
    });

    request.files.add(
        await http.MultipartFile.fromPath("user_image", userImage.path));
    request.files
        .add(await http.MultipartFile.fromPath("id_image", idImage.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201 || response.statusCode == 200) {
      return RegisterResponseModel.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception("Register failed");
    }
  }
}


import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AuthService {
  ///register
  Future<Response?> registerUser({
    required File image,
    required String name,
    required String email,
    required String password,
  }) async {
    late Response response;

    try {
      final Dio dio = Dio();

      MultipartFile multipartImage = await MultipartFile.fromFile(
        image.path,
        filename: "image",
        contentType: MediaType('image', 'jpeg'), // optional
      );

      FormData formData = FormData.fromMap({
        "image": multipartImage,
        "name": name,
        "email": email,
        "password": password,
      });
      response = await dio.post(
        "${Constants.url}/register",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      return response;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        return response = e.response!;
      }
      return null;
    }
  }

  ///login
  Future loginUser({required String email, required String password}) async {
    try {
      final url = Uri.parse("${Constants.url}/login");

      final http.Response response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      return response;
    } catch (e) {

      log(e.toString());
    }
  }
}

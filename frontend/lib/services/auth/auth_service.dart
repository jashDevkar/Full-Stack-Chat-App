import 'dart:convert';

import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<http.Response?> registerUser({
    required String image,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${Constants.url}/register");

      final response = await http.post(
        url,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'imageUrl':
              "https://yt3.ggpht.com/yti/ANjgQV-ouSo8nKvQ8z1g318n06gKuEP5I-m5K5hYa1Te_fwck9A=s88-c-k-c0x00ffffff-no-rj",
        }),
        headers: {'Content-Type': 'application/json'},
      );

      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

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
      print(e);
    }
  }
}

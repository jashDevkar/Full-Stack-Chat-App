import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  Future<http.Response?> registerUser({
    required String image,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("http://10.10.24.84:8000/register");

      final response = await http.post(
        url,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'image':
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
      final url = Uri.parse("http://10.10.24.84:800/login");

      final response = await http.post(
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

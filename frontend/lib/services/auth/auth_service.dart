import 'dart:convert';
import 'dart:io';

import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class AuthService {
  Future<http.StreamedResponse?> registerUser({
    required File image,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${Constants.url}/register");

      var request = http.MultipartRequest("POST", url);

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;

      // var _fileName = basename(image.path);

      var mimeType = lookupMimeType(image.path) ?? "application/octet-stream";

      print(image.path);

      request.files.add(
        await http.MultipartFile.fromPath(
          "image", // This is the key name in Express
          image.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      final response = await request.send();

      // final response = await http.post(
      //   url,
      //   body: jsonEncode({
      //     'name': name,
      //     'email': email,
      //     'password': password,
      //     'imageUrl':
      //         "https://yt3.ggpht.com/yti/ANjgQV-ouSo8nKvQ8z1g318n06gKuEP5I-m5K5hYa1Te_fwck9A=s88-c-k-c0x00ffffff-no-rj",
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );

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

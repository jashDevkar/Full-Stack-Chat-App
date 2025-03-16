import 'dart:convert';

import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<void> fetchAllUsers({String? userToken}) async {
    try {
      final url = Uri.parse("${Constants.url}/users/$userToken");
      final http.Response response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print(jsonDecode(response.body));
    } catch (e) {
      print(e);
    }
  }
}

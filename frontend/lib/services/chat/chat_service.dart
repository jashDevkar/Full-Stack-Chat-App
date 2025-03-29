import 'dart:async';
import 'dart:convert';

import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;

class ChatService {
  // final StreamController streamController = StreamController();

  Future<List> fetchAllUsers({String? userToken}) async {
    try {
      final url = Uri.parse("${Constants.url}/users/$userToken");
      
      final http.Response response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> sendFriendRequest() async {
    AuthBloc authBloc = AuthBloc();
    print(authBloc.user.email);
  }
}

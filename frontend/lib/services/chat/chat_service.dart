import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final BuildContext context;
  ChatService(this.context);
  final StreamController notificationUsers = StreamController();

  Future<List> fetchAllUsers({String? userToken}) async {
    try {
      final url = Uri.parse("${Constants.url}/users/");

      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$userToken',
        },
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> sendFriendRequest({
    required String senderToken,
    required String recieverId,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.parse("${Constants.url}/chat/send-friend-request/");

      final messenger = ScaffoldMessenger.of(context);

      final response = await http.post(
        url,
        body: jsonEncode({'recieverId': recieverId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': senderToken,
        },
      );

      if (response.statusCode == 201) {
        messenger.showSnackBar(SnackBar(content: Text('Friend request sent')));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> fetchAllFriends({String? userToken}) async {
    try {
      final url = Uri.parse("${Constants.url}/chat/all-friend-requests/");

      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$userToken',
        },
      );

      final data = jsonDecode(response.body);
      // print(data);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> acceptFriendRequest({
    required String senderToken,
    required String recieverId,
    required BuildContext context,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final url = Uri.parse("${Constants.url}/chat/accept-friend-request/");

      final response = await http.post(
        url,
        body: jsonEncode({'recieverId': recieverId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': senderToken,
        },
      );

      if (response.statusCode == 200) {
        messenger.showSnackBar(
          SnackBar(content: Text('Friend request accepted')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Server error')));
    }
  }
}

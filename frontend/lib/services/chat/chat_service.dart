import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final BuildContext context;
  ChatService(this.context);

  ///stream controllers
  final StreamController notificationUsers = StreamController();

  // static ChatService? _instance;

  // ChatService._privateConstructor(this.context);

  // factory ChatService(context) {
  //   return _instance ??= ChatService._privateConstructor(context);
  // }

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
      log(e.toString());
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

  Future<List> fetchAllFriendRequest({String? userToken}) async {
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
      log(e.toString());
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

  Future<List> fetchAllFriends({required String userToken}) async {
    try {
      final url = Uri.parse("${Constants.url}/chat/get-all-friends/");

      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userToken,
        },
      );

      final data = jsonDecode(response.body);
      if (data != null) {
        return data['friends'];
      }

      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List> getAllChats({
    required String userToken,
    required String recieverEmail,
  }) async {
    try {
      final url = Uri.parse("${Constants.url}/chat/messages/$recieverEmail");

      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userToken,
        },
      );

      final data = jsonDecode(response.body);
      if (data != null) {
        return data;
      }

      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}

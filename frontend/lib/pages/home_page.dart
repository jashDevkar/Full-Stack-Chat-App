import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel _userModel;

  ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _userModel = BlocProvider.of<AuthBloc>(context).user;
    chatService.fetchAllUsers(userToken: _userModel.token);
    // print(_userModel.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Home Page ${_userModel.email}"),
            TextButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(OnLogoutButtonPressed());
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

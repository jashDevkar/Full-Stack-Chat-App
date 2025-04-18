import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/bloc/chat_bloc.dart';

void showAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(Icons.error, color: Colors.red),
        title: Text('Hey user!'),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          ///cancel button
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),

          ///logout button
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600.withAlpha(200),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<ChatBloc>(context).add(EmptyAllFields());
              BlocProvider.of<AuthBloc>(context).add(OnLogoutButtonPressed());
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
  );
}

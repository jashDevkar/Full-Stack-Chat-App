import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Home Page"),
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

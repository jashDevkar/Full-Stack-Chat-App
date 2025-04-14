import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/auth/pages/register_page.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/chat/pages/home_page.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("myBox");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(CheckUserIsLogedIn())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: DarkTheme.theme,
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // if (state is AuthInitialLoading) {
          //   return const InitialPage();
          // }
          if (state is AuthLogedIn) {
            return const HomePage();
          } else {
            return const RegisterPage();
          }
        },
      ),
    );
  }
}

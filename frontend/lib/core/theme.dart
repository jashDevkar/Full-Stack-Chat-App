import 'package:flutter/material.dart';

class DarkTheme {
  static final theme = ThemeData.dark().copyWith(

    appBarTheme: AppBarTheme(),

    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      contentPadding: EdgeInsets.all(10.0),

      errorStyle: TextStyle(color: Colors.red),
    ),
  );
}

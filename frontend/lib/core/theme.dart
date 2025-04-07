import 'package:flutter/material.dart';

class DarkTheme {
  static final theme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple.shade600.withAlpha(100),
      // color: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: Colors.white),
      ),

      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),

      focusedErrorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      contentPadding: EdgeInsets.all(10.0),

      errorStyle: TextStyle(color: Colors.red),
    ),
  );
}

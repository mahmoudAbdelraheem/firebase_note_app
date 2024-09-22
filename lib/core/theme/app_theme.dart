import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
    ),
    
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.orange,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

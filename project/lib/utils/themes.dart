import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // Normal text
      bodyMedium: TextStyle(color: Colors.black), // Normal text
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white), // Text color for ElevatedButton
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white), // Text color for TextButton
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // Normal text
      bodyMedium: TextStyle(color: Colors.white), // Normal text
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.blueGrey), // Background color for ElevatedButton
        foregroundColor: WidgetStateProperty.all(Colors.black), // Text color for ElevatedButton
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.black), // Text color for TextButton
      ),
    ),
  );
}

import 'package:flutter/material.dart';

// Define your custom color palette
const Color primaryColorLight =
    Color.fromARGB(255, 255, 38, 0); // Blue for light theme
const Color primaryColorDark = Color(0xFF212121); // Dark grey for dark theme
const Color accentColorLight = Color(0xFFF0F0F0); // Light grey for light theme
const Color accentColorDark = Color(0xFF303030); // Darker grey for dark theme
const Color primarySwatch =
    Color.fromARGB(255, 247, 65, 10); // Darker grey for dark theme

// Create light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColorLight,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColorLight,
    titleTextStyle: TextStyle(color: Colors.white),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 20, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
      .copyWith(secondary: accentColorLight),
);

// Create dark theme


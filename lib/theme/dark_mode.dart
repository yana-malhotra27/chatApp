import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
  primary: Color(0xFFA2C9FF),             // #A2C9FF
  onPrimary: Color(0xFFFFFFFF),           // White
  primaryContainer: Color.fromARGB(194, 47, 65, 86),    // #D3E4FF
  onPrimaryContainer: Color(0xFF001C38),  // #001C38
  secondary: Color(0xFF000000),           // #EFF1F8 (used as Secondary Surface)
  onSecondary: Color(0xFF000000),         // Black
  surface: Color(0xFF000000),             // #F3F4F9 (Primary Surface)
  onSurface: Color(0xFF001E2F),           // #001E2F (On Surface 20)
  onSurfaceVariant: Color(0xFF44474E),    // #44474E (On Surface 40)
  outline: Color(0xFF74777F),             // #74777F (On Surface 60)
  error: Color(0xFFB00020),               // Standard Material error color
  onError: Color(0xFFFFFFFF),             // White
  errorContainer: Color(0xFFFCD8DF),      // Optional custom error container
  onErrorContainer: Color.fromARGB(255, 255, 255, 255),    // Optional custom contrast color
)
);
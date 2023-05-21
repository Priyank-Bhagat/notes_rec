import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      secondary: Colors.tealAccent.shade700,
    ),
    primaryColor: Colors.orange,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        // foregroundColor: Colors.black,
        // backgroundColor: Colors.grey.shade300,
        ),
  );

  final dartTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade800,
      secondary: Colors.tealAccent,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.white,
    ),
    primaryColor: Colors.orange,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        // foregroundColor: Colors.white,
        // backgroundColor: Colors.teal.shade500,
        ),
  );
}

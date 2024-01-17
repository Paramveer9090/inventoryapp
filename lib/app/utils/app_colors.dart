import 'package:flutter/material.dart';

class AppColors {
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color greyColor = Color(0xff343a40);
  static const Color darkRedColor = Color(0xFFc82333);
  static const Color primaryColor = Color(0Xff021a32);
  static const Color tableColor = Color(0Xff2b6095);
  static const Color secondPrimaryColor = Color(0XffB2365B);
  static const Color secondButtonColor = Color(0Xff777b83);
  static const Color elevatedButtonColor = Color(0xFF0069d9);
  static const Color textFillColor = Color(0xFFe1e2e8);
  static Color greyLightColor = Colors.grey.shade200;
  static const Color editButtonColor = Color(0xFF138496);
  static const Color addButtonColor = Color(0xFF218838);
  static const Color scaffoldBackgroundColor = Color(0xFFFFFFFF);
  static const Color lightGreen = Color(0xFF28a745);
  static const Color lightRed = Color(0xFFdc3545);
  static const Color lightYellow = Color(0xFFffae12);
  static const Color menuColor = Color(0xFF202020);
  static const Color arrowColor = Color(0xFF74777e);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    //
    appBarTheme: const AppBarTheme(
      backgroundColor: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
    ),
    //
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    //
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: elevatedButtonColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}

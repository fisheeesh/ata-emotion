import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ETextTheme {
  ETextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: EColors.dark,
      ),
    ),
    headlineMedium: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: EColors.dark,
      ),
    ),
    titleLarge: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: 18,
        color: EColors.white,
      ),
    ),
    titleMedium: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: 18,
        color: EColors.black,
      ),
    ),
    titleSmall: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: 16,
        color: EColors.black,
      ),
    ),
    labelLarge: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: 16,
        color: EColors.grey,
      ),
    ),
  );
}

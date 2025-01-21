import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ETextTheme {
  ETextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: ESizes.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: EColors.dark,
      ),
    ),
    titleLarge: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: ESizes.fontSizeMd,
        color: EColors.white,
      ),
    ),
    titleMedium: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: ESizes.fontSizeMd,
        color: EColors.black,
      ),
    ),
    labelLarge: GoogleFonts.lexend(
      textStyle: TextStyle(
        fontSize: ESizes.fontSizeSm,
        color: EColors.grey,
      ),
    ),
  );
}

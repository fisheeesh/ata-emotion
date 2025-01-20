import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/theme/text_theme.dart';

import 'package:flutter/material.dart';

class EAppTheme {
  // To keep the class constructor private
  EAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Lexend',
    brightness: Brightness.light,
    primaryColor: EColors.primary,
    scaffoldBackgroundColor: EColors.primaryBackground,
    textTheme: ETextTheme.lightTextTheme,
  );
}

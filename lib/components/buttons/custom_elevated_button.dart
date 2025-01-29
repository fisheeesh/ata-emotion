import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.placeholder,
  });

  final void Function()? onPressed;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: ESizes.md),
      decoration: BoxDecoration(
        color: EColors.secondary,
        border: Border.all(color: EColors.white),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFB4D2F1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 0)),
        ],
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: EColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ESizes.roundedLg),
            ),
            minimumSize: const Size.fromHeight(100),
          ),
          child: Text(
            placeholder,
            style: GoogleFonts.lexend(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: EColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

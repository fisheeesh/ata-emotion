import 'package:emotion_check_in_app/screens/main/home_screen.dart';
import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInSuccessScreen extends StatelessWidget {
  const CheckInSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ESizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkmark Icon
            _successIcon(),
            const SizedBox(height: 20),
            // Success Text
            _successMsg(),
            const SizedBox(height: 40),
            // White Card
            _checkInInfoCard(),
            const SizedBox(height: 40),
            // Home Button
            _backToHomButton(context)
          ],
        ),
      ),
    );
  }

  Container _checkInInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Time
          Text(
            ETexts.TIME,
            style: ETextTheme.lightTextTheme.labelMedium,
          ),
          const SizedBox(height: 10),
          Text(
            "09 : 41",
            style: ETextTheme.lightTextTheme.headlineMedium,
          ),
          const SizedBox(height: 20),

          // Emoji and Emotion Text
          Column(
            children: [
              const Text(
                "😩",
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                "stressed",
                style: ETextTheme.lightTextTheme.labelLarge,
              ),
              const SizedBox(height: 20),

              // Description Text
              Text(
                "Unfinished house chores and my boss is\nkeep asking me to do a lot of works.",
                textAlign: TextAlign.center,
                style: ETextTheme.lightTextTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text _successMsg() {
    return Text(
      ETexts.SUCCESS_MSG,
      style: ETextTheme.lightTextTheme.headlineMedium,
    );
  }

  Container _successIcon() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFD8EBE8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: EColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _backToHomButton(BuildContext context) {
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
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }, // Disable button if no emotion is selected
          style: ElevatedButton.styleFrom(
            backgroundColor: EColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ESizes.roundedLg),
            ),
            minimumSize: const Size.fromHeight(100),
          ),
          child: Text(
            ETexts.HOME,
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

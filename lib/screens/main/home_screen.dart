import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/screens/main/emotion_check_in_screen.dart';
import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  String _getGreetingMessage() {
    final hour = DateTime
        .now()
        .hour;

    if (hour >= 5 && hour < 12) {
      return ETexts.MORNING;
    } else if (hour >= 12 && hour < 17) {
      return ETexts.NOON;
    } else if (hour >= 17 && hour < 21) {
      return ETexts.EVENING;
    } else {
      return ETexts.NIGHT;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            left: ESizes.md, right: ESizes.md, top: ESizes.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Greeting and Logout Button
            _headerSection(authProvider, context),
            const SizedBox(height: 30),

            /// Calendar
            _calendarSection(),
            const SizedBox(height: 20),

            /// Check In Information
            _checkInInfoSection(),
            const Spacer(),

            /// Check In Button
            _checkInButton(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _checkInButton() {
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
        child:ElevatedButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmotionCheckInScreen()));
          }, // Disable button if no emotion is selected
          style: ElevatedButton.styleFrom(
            backgroundColor: EColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ESizes.roundedLg),
            ),
            minimumSize: const Size.fromHeight(100),
          ),
          child: Text(
            ETexts.CHECK_IN,
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

  Container _checkInInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: EColors.white,
        borderRadius: BorderRadius.circular(ESizes.roundedSm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 10, left: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFF7F8F8),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(Icons.login, color: Color(0xFFBAD6FE), size: 28,),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ETexts.CHECK_IN,
                    style: ETextTheme.lightTextTheme.titleMedium,
                  ),
                  Text(
                    "${_selectedDay.toLocal()}".split(' ')[0],
                    style: ETextTheme.lightTextTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
          Text(
            "9:41",
            style: ETextTheme.lightTextTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Container _calendarSection() {
    return Container(
      decoration: BoxDecoration(
        color: EColors.white,
        borderRadius: BorderRadius.circular(ESizes.roundedSm),
        boxShadow: [
          BoxShadow(
            color: EColors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: ESizes.sm, right: ESizes.sm, bottom: ESizes.sm),
        child: TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: EColors.dark),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: EColors.lightBlue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: EColors.onTimeColor,
              shape: BoxShape.circle,
            ),
            weekendDecoration: BoxDecoration(
              color: EColors.lateColor,
              shape: BoxShape.circle,
            ),
            holidayTextStyle: const TextStyle(color: EColors.lateColor),
            weekendTextStyle: const TextStyle(color: EColors.dark),
            defaultDecoration: BoxDecoration(
              color: EColors.onTimeColor,
              shape: BoxShape.circle,
            ),
            defaultTextStyle: const TextStyle(color: EColors.dark),
            outsideDaysVisible: false,
          ),
        ),
      ),
    );
  }

  Row _headerSection(AuthProvider authProvider, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreetingMessage(),
              style: ETextTheme.lightTextTheme.headlineMedium,
            ),
            Text(
              authProvider.userName ?? ETexts.DEFAULT_TEXT,
              style: ETextTheme.lightTextTheme.labelLarge,
            ),
          ],
        ),
        _logOutButton(context),
      ],
    );
  }

  OutlinedButton _logOutButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        // Show confirmation dialog
        final shouldLogout = await _showLogoutConfirmationDialog(context);

        if (shouldLogout) {
          // Handle logout
          await context.read<AuthProvider>().logout(context);
        }
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: EColors.lightGary, width: 1.5),
        foregroundColor: EColors.danger,
      ),
      child: Text(
        ETexts.LOGOUT,
        style: GoogleFonts.lexend(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: EColors.white,
          title: Text(
            ETexts.DIALOG_TITLE,
            style: ETextTheme.lightTextTheme.headlineMedium,
          ),
          content: Text(
            ETexts.DIALOG_CONTEXT,
            style: ETextTheme.lightTextTheme.titleSmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                /// Dismiss the dialog and return false
                Navigator.of(context).pop(false);
              },
              child: const Text(
                ETexts.CANCEL,
                style: TextStyle(color: EColors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                /// Dismiss the dialog and return true
                Navigator.of(context).pop(true);
              },
              child: const Text(
                ETexts.OK,
                style: TextStyle(color: EColors.black),
              ),
            ),
          ],
        );
      },
    ) ??

        /// If the dialog is dismissed without a choice, return false
        false;
  }
}

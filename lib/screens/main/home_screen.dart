import 'package:emotion_check_in_app/components/buttons/custom_elevated_button.dart';
import 'package:emotion_check_in_app/models/emotion_check_in.dart';
import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/provider/emotion_check_in_provider.dart';
import 'package:emotion_check_in_app/screens/main/emotion_check_in_screen.dart';
import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/helpers/helper_functions.dart';
import 'package:emotion_check_in_app/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
    final hour = DateTime.now().hour;

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
    final checkInProvider = context.watch<EmotionCheckInProvider>();
    final userName =
        context.watch<AuthProvider>().userName ?? ETexts.DEFAULT_TEXT;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            left: ESizes.md, right: ESizes.md, top: ESizes.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Greeting and Logout Button
            _headerSection(userName, context),
            const SizedBox(height: 30),

            /// Calendar
            _calendarSection(checkInProvider),
            const SizedBox(height: 20),

            /// Check In Information
            _checkInInfoSection(checkInProvider),
            const Spacer(),

            /// Check In Button
            _checkInButton(checkInProvider, userName),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _checkInButton(
      EmotionCheckInProvider checkInProvider, String userName) {
    return CustomElevatedButton(
        onPressed: checkInProvider.todayCheckIn != null
            ? null
            : () {
                final now = DateTime.now();
                EHelperFunctions.navigateToScreen(
                    context,
                    EmotionCheckInScreen(
                      userName: userName,
                      checkInTime: now,
                    ));
              },
        placeholder: ETexts.CHECK_IN);
  }

  Widget _checkInInfoSection(EmotionCheckInProvider checkInProvider) {
    final selectedDayCheckIn = checkInProvider.getCheckInByDate(_selectedDay);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: selectedDayCheckIn != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.login,
                        color: EColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ETexts.CHECK_IN,
                          style: ETextTheme.lightTextTheme.titleMedium,
                        ),
                        Text(
                          /// Display user's selected day
                          EHelperFunctions.getFormattedDate(
                              selectedDayCheckIn.checkInTime, 'MMMM d, yyyy'),
                          style: ETextTheme.lightTextTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '${selectedDayCheckIn.checkInTime.hour}:${selectedDayCheckIn.checkInTime.minute.toString().padLeft(2, '0')}',
                  style: ETextTheme.lightTextTheme.titleMedium,
                ),
              ],
            )
          : Center(
              child: Text(
                ETexts.NO_CHECK_IN,
                style: ETextTheme.lightTextTheme.labelLarge,
              ),
            ),
    );
  }

  Widget _calendarSection(EmotionCheckInProvider checkInProvider) {
    final checkInList = checkInProvider.checkInList;

    Map<DateTime, CheckInType> checkInTypeMap = {
      for (var checkIn in checkInList)
        DateTime(checkIn.checkInTime.year, checkIn.checkInTime.month,
            checkIn.checkInTime.day): checkIn.checkInType,
    };

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
        padding: const EdgeInsets.all(ESizes.sm),
        child: TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: EColors.dark,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: EColors.dark),
            rightChevronIcon: Icon(Icons.chevron_right, color: EColors.dark),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: const TextStyle(color: EColors.dark),
            weekendTextStyle: const TextStyle(color: EColors.dark),
            todayDecoration: BoxDecoration(),

            /// No highlight for today
            selectedDecoration: BoxDecoration(),

            /// No highlight for default selection
            rangeHighlightColor: Colors.transparent,

            /// No range highlight
            markerDecoration: BoxDecoration(),

            /// No default markers
            cellMargin: const EdgeInsets.all(4),
          ),
          availableGestures: AvailableGestures.horizontalSwipe,

          /// Highlight each day with custom colors
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              /// Always set the day text color to black
              /// @TODO: will modify later
              return Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: EColors.dark),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              /// Handle selection style based on check-in type
              final checkInType =
                  checkInTypeMap[DateTime(day.year, day.month, day.day)];

              if (checkInType == CheckInType.onTime) {
                return _buildHighlightedDay(day, EColors.onTimeColor);
              } else if (checkInType == CheckInType.late) {
                return _buildHighlightedDay(day, EColors.lateColor);
              } else if (day.isAfter(DateTime.now())) {
                /// Upcoming days
                return _buildHighlightedDay(day, EColors.lightBlue);
              } else {
                /// Default highlight for unlisted or past days
                return _buildHighlightedDay(day, EColors.lightBlue);
              }
            },
            markerBuilder: (context, day, events) {
              /// Highlight the day based on check-in type
              final checkInType =
                  checkInTypeMap[DateTime(day.year, day.month, day.day)];

              if (checkInType == CheckInType.onTime) {
                return _buildHighlightedDay(day, EColors.onTimeColor);
              } else if (checkInType == CheckInType.late) {
                return _buildHighlightedDay(day, EColors.lateColor);
              }

              /// Default text for days without check-in
              return Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: EColors.dark),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedDay(DateTime day, Color color) {
    return Center(
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: EColors.dark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Row _headerSection(String userName, BuildContext context) {
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
              userName,
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
                ETexts.LOGOUT_TITLE,
                style: ETextTheme.lightTextTheme.headlineMedium,
              ),
              content: Text(
                ETexts.LOGOUT_CONTENT,
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
        false;
  }
}

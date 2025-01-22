import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/screens/auth/login_screen.dart';
import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Padding(
        padding: const EdgeInsets.only(left: ESizes.md, right: ESizes.md, top: ESizes.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Greeting and Logout Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreetingMessage(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Users',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () async{
                    // Handle logout
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.logout();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    EHelperFunctions.showSnackBar(context, 'Logout Successfully.');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: EColors.danger),
                    foregroundColor: EColors.danger,
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Calendar
            Container(
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
                padding: const EdgeInsets.only(left: ESizes.sm, right: ESizes.sm, bottom: ESizes.sm),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: EColors.dark
                    ),
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
            ),
            const SizedBox(height: 20),

            // Check In Information
            Container(
              padding: const EdgeInsets.symmetric(horizontal: ESizes.sm, vertical: 12),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Check In",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${_selectedDay.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "9:41",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "On Time",
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Check In Button
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle Check-In logic
                },
                child: Container(
                  width: ESizes.wFull,
                  height: ESizes.hSm,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: EColors.primary,
                    borderRadius: BorderRadius.circular(ESizes.roundedLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Check In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
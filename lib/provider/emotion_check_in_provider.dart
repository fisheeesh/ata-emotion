import 'package:emotion_check_in_app/models/emotion_check_in.dart';
import 'package:flutter/material.dart';

class EmotionCheckInProvider with ChangeNotifier {
  final List<EmotionCheckIn> _checkInList = [
    EmotionCheckIn(
      userName: "Swam Yi Phyo",
      checkInTime: DateTime(2025, 1, 22, 8, 45), // January 22, On Time
      emoji: "😊",
      label: "Happy",
      feeling: "Feeling great today!",
      checkInType: CheckInType.onTime,
    ),
    EmotionCheckIn(
      userName: "Swam Yi Phyo",
      checkInTime: DateTime(2025, 1, 24, 10, 15), // January 24, Late
      emoji: "😟",
      label: "Stressed",
      feeling: "Feeling overwhelmed.",
      checkInType: CheckInType.late,
    ),
    EmotionCheckIn(
      userName: "Swam Yi Phyo",
      checkInTime: DateTime(2025, 1, 25, 8, 50), // January 25, On Time
      emoji: "😊",
      label: "Content",
      feeling: "All good.",
      checkInType: CheckInType.onTime,
    ),
    EmotionCheckIn(
      userName: "Swam Yi Phyo",
      checkInTime: DateTime(2025, 1, 26, 11, 0), // January 26, Late
      emoji: "😴",
      label: "Tired",
      feeling: "Didn't sleep well.",
      checkInType: CheckInType.late,
    ),
    EmotionCheckIn(
      userName: "Swam Yi Phyo",
      checkInTime: DateTime(2025, 1, 27, 8, 20), // January 27, On Time
      emoji: "😀",
      label: "Excited",
      feeling: "Looking forward to the day!",
      checkInType: CheckInType.onTime,
    ),
  ];

  // Getters
  List<EmotionCheckIn> get checkInList => _checkInList;

  EmotionCheckIn? get todayCheckIn {
    final today = DateTime.now();
    return _checkInList.cast<EmotionCheckIn?>().firstWhere(
          (checkIn) =>
      checkIn!.checkInTime.day == today.day &&
          checkIn.checkInTime.month == today.month &&
          checkIn.checkInTime.year == today.year,
      orElse: () => null,
    );
  }

  // Add a new check-in
  void addCheckIn(String userName, DateTime checkInTime, String emoji, String label, String feeling) {
    final checkInType = _determineCheckInType(checkInTime);
    final newCheckIn = EmotionCheckIn(
      userName: userName,
      checkInTime: checkInTime,
      emoji: emoji,
      label: label,
      feeling: feeling,
      checkInType: checkInType,
    );

    _checkInList.add(newCheckIn);
    notifyListeners();
  }

  // Get a check-in for a specific date
  EmotionCheckIn? getCheckInByDate(DateTime date) {
    try {
      return _checkInList.firstWhere(
            (checkIn) =>
        checkIn.checkInTime.year == date.year &&
            checkIn.checkInTime.month == date.month &&
            checkIn.checkInTime.day == date.day,
      );
    } catch (e) {
      return null; // If no match is found, return null
    }
  }

  // Determine if the check-in is "on time" or "late"
  CheckInType _determineCheckInType(DateTime checkInTime) {
    final today = DateTime(checkInTime.year, checkInTime.month, checkInTime.day);
    final onTimeEnd = DateTime(today.year, today.month, today.day, 9, 30); // 9:30 AM
    return checkInTime.isBefore(onTimeEnd) ? CheckInType.onTime : CheckInType.late;
  }
}
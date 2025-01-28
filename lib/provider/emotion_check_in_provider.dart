import 'package:emotion_check_in_app/models/emotion_check_in.dart';
import 'package:flutter/material.dart';

class EmotionCheckInProvider with ChangeNotifier {
  final List<EmotionCheckIn> _checkInList = [];

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

  // Determine if the check-in is "on time" or "late"
  CheckInType _determineCheckInType(DateTime checkInTime) {
    final today = DateTime.now();
    final onTimeEnd = DateTime(today.year, today.month, today.day, 9, 30); // 9:30 AM
    return checkInTime.isBefore(onTimeEnd) ? CheckInType.onTime : CheckInType.late;
  }
}
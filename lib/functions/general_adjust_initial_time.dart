import 'package:flutter/material.dart';

class GeneralAdjustedInitialTime {
  static adjustedInitialTime(TimeOfDay? timeOfDay) {
    final now = TimeOfDay.now();
    final initialDateTime = TimeOfDay(
      hour: timeOfDay?.hour ?? now.hour,
      minute: timeOfDay?.minute ?? now.minute,
    );

    int minuteInterval = 5;
    int adjustedMinute = (initialDateTime.minute + minuteInterval - 1) ~/ minuteInterval * minuteInterval;

    if (adjustedMinute >= 60) {
      adjustedMinute -= 60;
      return TimeOfDay(
        hour: initialDateTime.hour + 1,
        minute: adjustedMinute,
      );
    }

    return TimeOfDay(
      hour: initialDateTime.hour,
      minute: adjustedMinute,
    );
  }
}

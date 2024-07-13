import 'package:flutter/material.dart';

class GeneralFormatTime {
  static String formatInteractionTime(TimeOfDay? time) {
    if (time == null) {
      return '시간';
    } else {
      final hours = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final period = time.hour < 12 ? '오전' : '오후';
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$period $hours:$minutes';
    }
  }

  static String formatShowTime(DateTime time) {
    final hours = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? '오전' : '오후';
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$period $hours:$minutes';
  }
}

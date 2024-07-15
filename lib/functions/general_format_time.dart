import 'package:flutter/material.dart';
import 'package:plus_todo/models/day_of_week.dart';

class GeneralFormatTime {
  static String formatDetailDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일(${dayOfWeekToKorean(DayOfWeek.values[date.weekday - 1])})';
  }

  static String formatDate(DateTime date) {
    return '${date.year}.${date.month}.${date.day}.(${dayOfWeekToKorean(DayOfWeek.values[date.weekday - 1])})';
  }

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

  static String formatTime(DateTime time) {
    final hours = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? '오전' : '오후';
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$period $hours:$minutes';
  }
}

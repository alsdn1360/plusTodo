import 'package:flutter/material.dart';
import 'package:plus_todo/models/day_of_week.dart';

class GeneralFormatTime {
  static String formatDetailDate(DateTime date) {
    int currentYear = DateTime.now().year;

    if (date.year == currentYear) {
      return '${date.month}월 ${date.day}일(${dayOfWeekToKorean(DayOfWeek.values[date.weekday - 1])})';
    } else {
      return '${date.year}년 ${date.month}월 ${date.day}일(${dayOfWeekToKorean(DayOfWeek.values[date.weekday - 1])})';
    }
  }

  static String formatDate(DateTime date) {
    int currentYear = DateTime.now().year;

    if (date.year == currentYear) {
      return '${date.month}월 ${date.day}일(${dayOfWeekToKorean(DayOfWeek.values[date.weekday - 1])}), ${formatTime(date)}';
    } else {
      return '${date.year}년 ${date.month}월 ${date.day}일(${dayOfWeekToKorean(DayOfWeek.values[date.weekday - 1])}), ${formatTime(date)}';
    }
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

  static String formatNotificationTime(int minuteBefore) {
    int hours = minuteBefore ~/ 60;

    if (minuteBefore == 0) {
      return '마감 시간';
    } else if (minuteBefore < 60) {
      return '$minuteBefore분 전';
    } else {
      return '$hours시간 전';
    }
  }

  static String formatDeadline(DateTime deadline) {
    int currentYear = DateTime.now().year;

    if (deadline.year == currentYear) {
      return '${deadline.month}월${deadline.day}일(${dayOfWeekToKorean(DayOfWeek.values[deadline.weekday - 1])}), '
          '${formatTime(deadline)}까지';
    } else {
      return '${deadline.year}년${deadline.month}월${deadline.day}일(${dayOfWeekToKorean(DayOfWeek.values[deadline.weekday - 1])}), '
          '${formatTime(deadline)}까지';
    }
  }
}

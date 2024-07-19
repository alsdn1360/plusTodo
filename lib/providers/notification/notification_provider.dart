// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, int>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<int> {
  NotificationNotifier() : super(30) {
    _loadNotificationTime();
  }

  Future<void> _loadNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final minutes = prefs.getInt('notificationTime') ?? 30;
      state = minutes;
    }catch(e) {
      print('알림 시간 불러오기 실패: $e');
    }
  }

  Future<void> _saveNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('notificationTime', state);
    } catch(e) {
      print('알림 시간 저장 실패: $e');
    }
  }

  Future<void> updateNotificationTime(int minutes) async {
    try {
      state = minutes;
      await _saveNotificationTime();
    } catch(e) {
      print('알림 시간 업데이트 실패: $e');
    }
  }
}

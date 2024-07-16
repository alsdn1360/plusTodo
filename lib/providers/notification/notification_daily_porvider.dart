// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationDailyProvider = StateNotifierProvider<NotificationTimeNotifier, Map>((ref) {
  return NotificationTimeNotifier();
});

class NotificationTimeNotifier extends StateNotifier<Map> {
  NotificationTimeNotifier() : super({"hour": 9, "minute": 0}) {
    _loadNotificationTime();
  }

  Future<void> _loadNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hour = prefs.getInt('notiHour') ?? 9;
      final minute = prefs.getInt('notiMinute') ?? 0;
      state = {"hour": hour, "minute": minute};
    } catch (e) {
      print('알림 시간 불러오기 실패: $e');
    }
  }

  Future<void> _saveNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('notiHour', state['hour']);
      await prefs.setInt('notiMinute', state['minute']);
    } catch (e) {
      print('알림 시간 저장 실패: $e');
    }
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    try {
      state = {"hour": hour, "minute": minute};
      await _saveNotificationTime();
    } catch (e) {
      print('알림 시간 설정 실패: $e');
    }
  }
}

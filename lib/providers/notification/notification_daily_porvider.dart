// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationDailyProvider = StateNotifierProvider<NotificationDailyNotifier, Map>((ref) {
  return NotificationDailyNotifier();
});

class NotificationDailyNotifier extends StateNotifier<Map> {
  NotificationDailyNotifier()
      : super({
          "isNotification": false,
          "hour": 9,
          "minute": 0,
        }) {
    _loadDailyNotificationTime();
  }

  Future<void> _loadDailyNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isNotification = prefs.getBool('isNotification') ?? false;
      final hour = prefs.getInt('notiHour') ?? 9;
      final minute = prefs.getInt('notiMinute') ?? 0;
      state = {"isNotification": isNotification, "hour": hour, "minute": minute};
    } catch (e) {
      print('알림 시간 불러오기 실패: $e');
    }
  }

  Future<void> _saveDailyNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isNotification', state['isNotification']);
      await prefs.setInt('notiHour', state['hour']);
      await prefs.setInt('notiMinute', state['minute']);
    } catch (e) {
      print('알림 시간 저장 실패: $e');
    }
  }

  Future<void> setDailyNotificationTime(int hour, int minute) async {
    try {
      state = {"isNotification": true, "hour": hour, "minute": minute};
      await _saveDailyNotificationTime();
    } catch (e) {
      print('알림 시간 설정 실패: $e');
    }
  }

  Future<void> toggleDailyNotification(bool isNotification) async {
    try {
      state = {"isNotification": isNotification, "hour": state['hour'], "minute": state['minute']};
      await _saveDailyNotificationTime();
    } catch (e) {
      print('알림 설정 실패: $e');
    }
  }
}

// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final calendarWeekSettingProvider = StateNotifierProvider<CalendarWeekSettingNotifier, Map>((ref) {
  return CalendarWeekSettingNotifier();
});

class CalendarWeekSettingNotifier extends StateNotifier<Map> {
  CalendarWeekSettingNotifier()
      : super({
          "startingWeekday": 7,
          "saturdayHighlight": true,
          "sundayHighlight": true,
        }) {
    _loadWeekSetting();
  }

  Future<void> _loadWeekSetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final startingWeekday = prefs.getInt('startingWeekday') ?? 7;
      final saturdayHighlight = prefs.getBool('saturdayHighlight') ?? true;
      final sundayHighlight = prefs.getBool('sundayHighlight') ?? true;
      state = {
        "startingWeekday": startingWeekday,
        "saturdayHighlight": saturdayHighlight,
        "sundayHighlight": sundayHighlight,
      };
    } catch (e) {
      print('주말 강조 불러오기 실패: $e');
    }
  }

  Future<void> _saveWeekSetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('startingWeekday', state['startingWeekday']);
      await prefs.setBool('saturdayHighlight', state['saturdayHighlight']);
      await prefs.setBool('sundayHighlight', state['sundayHighlight']);
    } catch (e) {
      print('주말 강조 저장 실패: $e');
    }
  }

  Future<void> changeStartingWeekday(int startingWeekday) async {
    try {
      state = {
        "startingWeekday": startingWeekday,
        "saturdayHighlight": state['saturdayHighlight'],
        "sundayHighlight": state['sundayHighlight'],
      };
      await _saveWeekSetting();
    } catch (e) {
      print('시작 요일 설정 실패: $e');
    }
  }

  Future<void> toggleSaturdayHighlight(bool saturdayHighlight) async {
    try {
      state = {
        "startingWeekday": state['startingWeekday'],
        "saturdayHighlight": saturdayHighlight,
        "sundayHighlight": state['sundayHighlight'],
      };
      await _saveWeekSetting();
    } catch (e) {
      print('토요일 강조 설정 실패: $e');
    }
  }

  Future<void> toggleSundayHighlight(bool sundayHighlight) async {
    try {
      state = {
        "startingWeekday": state['startingWeekday'],
        "saturdayHighlight": state['saturdayHighlight'],
        "sundayHighlight": sundayHighlight,
      };
      await _saveWeekSetting();
    } catch (e) {
      print('일요일 강조 설정 실패: $e');
    }
  }
}

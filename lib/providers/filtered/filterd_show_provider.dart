// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filteredShowProvider = StateNotifierProvider<FilteredShowNotifier, bool>((ref) {
  return FilteredShowNotifier(false);
});

class FilteredShowNotifier extends StateNotifier<bool> {
  FilteredShowNotifier(super.state) {
    _loadFilteredShow();
  }

  Future<void> _loadFilteredShow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filteredShow = prefs.getBool('filteredShowUncompleted') ?? false;
      state = filteredShow;
    } catch (e) {
      print('완료된 할 일 목록 보여주기/숨기기 불러오기 실패: $e');
    }
  }

  Future<void> _saveFilteredShow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('filteredShowUncompleted', state);
    } catch (e) {
      print('완료된 할 일 목록 보여주기/숨기기 저장 실패: $e');
    }
  }

  Future<void> toggleFilteredShow(bool isShow) async {
    try {
      state = isShow;
      await _saveFilteredShow();
    } catch (e) {
      print('완료된 할 일 목록 보여주기/숨기기 토글 실패: $e');
    }
  }
}

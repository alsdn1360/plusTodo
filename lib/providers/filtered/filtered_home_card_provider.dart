// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filteredHomeCardIndexProvider = StateNotifierProvider<FilteredHomeCardIndexNotifier, int>((ref) {
  return FilteredHomeCardIndexNotifier(1);
});

class FilteredHomeCardIndexNotifier extends StateNotifier<int> {
  FilteredHomeCardIndexNotifier(super.state) {
    _loadFilteredHomeCardIndex();
  }

  Future<void> _loadFilteredHomeCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filteredCardIndex = prefs.getInt('filteredCardIndex') ?? 1;
      state = filteredCardIndex;
    } catch (e) {
      print('개요 카드 인덱스 불러오기 실패: $e');
    }
  }

  Future<void> _saveFilteredHomeCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('filteredCardIndex', state);
    } catch (e) {
      print('개요 카드 인덱스 저장 실패: $e');
    }
  }

  Future<void> toggleFilteredHomeCardIndex(int index) async {
    try {
      state = index;
      await _saveFilteredHomeCardIndex();
    } catch (e) {
      print('개요 카드 인덱스 토글 실패: $e');
    }
  }
}

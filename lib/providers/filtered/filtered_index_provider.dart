// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filteredIndexProvider = StateNotifierProvider<FilteredIndexNotifier, int>((ref) {
  return FilteredIndexNotifier(1);
});

class FilteredIndexNotifier extends StateNotifier<int> {
  FilteredIndexNotifier(super.state) {
    _loadFilteredIndex();
  }

  Future<void> _loadFilteredIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filteredIndex = prefs.getInt('filteredIndexDoData') ?? 1;
      state = filteredIndex;
    } catch (e) {
      print('정렬 인덱스 불러오기 실패: $e');
    }
  }

  Future<void> _saveFilteredIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('filteredIndexDoData', state);
    } catch (e) {
      print('정렬 인덱스 저장 실패: $e');
    }
  }

  Future<void> toggleFilteredIndex(int index) async {
    try {
      state = index;
      await _saveFilteredIndex();
    } catch (e) {
      print('정렬 인덱스 토글 실패: $e');
    }
  }
}

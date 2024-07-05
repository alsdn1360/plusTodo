// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filteredCardIndexProvider = StateNotifierProvider<FilteredCardIndexNotifier, int>((ref) {
  return FilteredCardIndexNotifier(1);
});

class FilteredCardIndexNotifier extends StateNotifier<int> {
  FilteredCardIndexNotifier(super.state) {
    _loadFilteredCardIndex();
  }

  Future<void> _loadFilteredCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filteredCardIndex = prefs.getInt('filteredCardIndex') ?? 1;
      state = filteredCardIndex;
    } catch (e) {
      print('개요 카드 인덱스 불러오기 실패: $e');
    }
  }

  Future<void> _saveFilteredCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('filteredCardIndex', state);
    } catch (e) {
      print('개요 카드 인덱스 저장 실패: $e');
    }
  }

  Future<void> toggleFilteredCardIndex(int index) async {
    try {
      state = index;
      await _saveFilteredCardIndex();
    } catch (e) {
      print('개요 카드 인덱스 토글 실패: $e');
    }
  }
}

// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filteredShowListOrCardProvider = StateNotifierProvider<FilteredShowListOrCardNotifier, int>((ref) {
  return FilteredShowListOrCardNotifier(0);
});

class FilteredShowListOrCardNotifier extends StateNotifier<int> {
  FilteredShowListOrCardNotifier(super.state) {
    _loadFilteredShowListOrCard();
  }

  Future<void> _loadFilteredShowListOrCard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filteredCardIndex = prefs.getInt('filteredCardIndex') ?? 0;
      state = filteredCardIndex;
    } catch (e) {
      print('카드 및 리스트 불러오기 실패: $e');
    }
  }

  Future<void> _saveFilteredShowListOrCard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('filteredCardIndex', state);
    } catch (e) {
      print('카드 및 리스트 저장 실패: $e');
    }
  }

  Future<void> toggleFilteredShowListOrCard(int index) async {
    try {
      state = index;
      await _saveFilteredShowListOrCard();
    } catch (e) {
      print('카드 및 리스트 토글 실패: $e');
    }
  }
}

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
      print('Failed to load filteredIndex: $e');
    }
  }

  Future<void> _saveFilteredIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('filteredIndexDoData', state);
    } catch (e) {
      print('Failed to save filteredIndex: $e');
    }
  }

  Future<void> toggleFilteredIndex(int index) async {
    try {
      state = index;
      await _saveFilteredIndex();
    } catch (e) {
      print('Failed to toggle filteredIndex: $e');
    }
  }
}

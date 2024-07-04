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
      print('Failed to load filteredShow: $e');
    }
  }

  Future<void> _saveFilteredShow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('filteredShowUncompleted', state);
    } catch (e) {
      print('Failed to save filteredShow: $e');
    }
  }

  Future<void> toggleFilteredShow(bool isShow) async {
    try {
      state = isShow;
      await _saveFilteredShow();
    } catch (e) {
      print('Failed to toggle filteredShow: $e');
    }
  }
}

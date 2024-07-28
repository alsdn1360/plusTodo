import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarSelectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final calendarLastedSelectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final calendarFocusedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
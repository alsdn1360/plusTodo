import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoSelectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final todoFocusedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
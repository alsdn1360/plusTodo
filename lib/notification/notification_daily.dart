import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> dailyNotification({
  required String content,
}) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final prefs = await SharedPreferences.getInstance();

  final hour = prefs.getInt('notiHour') ?? 9;
  final minute = prefs.getInt('notiMinute') ?? 0;

  var android = AndroidNotificationDetails(
    'daily_todo_id',
    '오늘 해야 할 일을 확인하세요!',
    channelDescription: content,
    importance: Importance.max,
    priority: Priority.max,
  );

  var ios = const DarwinNotificationDetails();

  var detail = NotificationDetails(android: android, iOS: ios);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    '오늘 해야 할 일을 확인하세요!',
    content,
    _dailyTime(hour, minute),
    detail,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _dailyTime(int hour, int minute) {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
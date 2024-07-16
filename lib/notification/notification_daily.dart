import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> dailyNotification({
  required int idx,
  required String title,
  required String content,
  required int notiHour,
  required int notiMinute,
}) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var android = AndroidNotificationDetails(
    'daily_todo_id',
    title,
    channelDescription: content,
    importance: Importance.max,
    priority: Priority.max,
  );

  var ios = const DarwinNotificationDetails();

  var detail = NotificationDetails(android: android, iOS: ios);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    idx,
    title,
    content,
    _dailyTime(notiHour, notiMinute),
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

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plus_todo/themes/custom_color.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> sendNotification({
  required int idx,
  required DateTime date,
  required String title,
  required String content,
}) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool? result;

  if (Platform.isAndroid) {
    result = true;
  } else {
    result = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  var android = AndroidNotificationDetails(
    'id',
    title,
    channelDescription: content,
    importance: Importance.max,
    priority: Priority.max,
    color: white,
  );

  var ios = const DarwinNotificationDetails();

  var detail = NotificationDetails(android: android, iOS: ios);

  if (result == true) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      idx,
      title,
      content,
      _setNotificationTime(date: date),
      detail,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}

tz.TZDateTime _setNotificationTime({required DateTime date}) {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  final deadline = tz.TZDateTime.from(date, tz.local);
  return deadline.subtract(const Duration(hours: 1));
}

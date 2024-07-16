import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plus_todo/pages/notification/notification_setting_page.dart';

class HomeNotificationSettingIconButton extends StatelessWidget {
  const HomeNotificationSettingIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const NotificationSettingPage(),
        ),
      ),
      icon: const Icon(Icons.notifications_rounded),
    );
  }
}

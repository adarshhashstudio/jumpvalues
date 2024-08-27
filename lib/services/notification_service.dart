import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/dashboard/dashboard.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationManager._internal() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        _onSelectNotification(notificationResponse);
      },
    );
  }

  /// Shows a notification with the given [title] and [body].
  Future<void> showNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        importance: Importance.max, priority: Priority.high);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'Notification Payload');
  }

  /// Handles what happens when a notification is tapped.
  Future<void> _onSelectNotification(
      NotificationResponse notificationResponse) async {
    debugPrint(
        'Notification tapped with payload: ${notificationResponse.payload}');

    // Navigate to the dashboard or another specific screen
    // You need to pass the BuildContext or use a global navigator key.
    // For this example, we'll use a navigator key.

    await Navigator.of(NavigationService.navigatorKey.currentState!.context)
        .push(MaterialPageRoute(
            builder: (context) => Dashboard(
                  index: 1,
                  isRedirect: true,
                )));
  }
}

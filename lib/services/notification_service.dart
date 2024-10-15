import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/dashboard/dashboard.dart';

class NotificationManager {
  NotificationManager._internal() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android settings
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    final initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    // Combine settings for both platforms
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );
  }

  factory NotificationManager() => _instance;
  static final NotificationManager _instance = NotificationManager._internal();

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  /// Shows a notification with the given [title] and [body].
  Future<void> showNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosPlatformChannelSpecifics = DarwinNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  /// Handles what happens when a notification is tapped.
  Future<void> _onSelectNotification(
      NotificationResponse notificationResponse) async {
    debugPrint(
        'Notification tapped with payload: ${notificationResponse.payload}');

    await Navigator.of(NavigationService.navigatorKey.currentState!.context)
        .push(MaterialPageRoute(
            builder: (context) => Dashboard(
                  index: 1,
                  isRedirect: true,
                )));
  }

  /// Handles what happens when a notification is received on iOS in the foreground.
  Future<void> _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    debugPrint(
        'iOS notification received: title=$title, body=$body, payload=$payload');
    // Handle the iOS local notification
  }
}

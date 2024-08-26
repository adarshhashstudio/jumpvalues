import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

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
}

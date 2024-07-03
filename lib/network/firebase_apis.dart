import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/auth_screens/login_screen.dart';
import 'package:jumpvalues/screens/dashboard/dashboard.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    var settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    try {
      var fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $fcmToken');
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }

    await initPushNotifications();
    await initLocalNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    if (kDebugMode) {
      debugPrint('Notification Title: ${message.notification?.title}');
      debugPrint('Notification Body: ${message.notification?.body}');
    }
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
      Navigator.push(
        NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            isRedirect: true,
            index: 1,
          ),
        ),
      );
    });
    FirebaseMessaging.onMessage.listen(showNotification);
  }

  Future<void> initLocalNotifications() async {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: handleNavigation,
    );
  }

  Future<void> handleNavigation(NotificationResponse response) async {
    if (response.payload != null) {
      if (appStore.isLoggedIn) {
        if (appStore.userTypeCoach) {
          await Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                isRedirect: true,
                index: 0,
              ),
            ),
          );
        } else {
          await Navigator.push(
            NavigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                isRedirect: true,
                index: 1,
              ),
            ),
          );
        }
      } else {
        await Navigator.push(
          NavigationService.navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        ).then((v) {
          if (appStore.userTypeCoach) {
            Navigator.push(
              NavigationService.navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  isRedirect: true,
                  index: 0,
                ),
              ),
            );
          } else {
            Navigator.push(
              NavigationService.navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  isRedirect: true,
                  index: 1,
                ),
              ),
            );
          }
        });
      }
    }
  }

  Future<void> showNotification(RemoteMessage? message) async {
    if (message == null) return;

    var channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.high,
    );

    var androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'JumpCC Channel',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: 'notification_payload',
    );
  }
}

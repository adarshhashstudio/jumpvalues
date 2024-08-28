import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/services/notification_service.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketAndNotifications {
  // Factory constructor to return the singleton instance
  factory SocketAndNotifications() => _instance;

  // Private constructor for internal use
  SocketAndNotifications._internal();
  // Singleton instance
  static final SocketAndNotifications _instance =
      SocketAndNotifications._internal();

  IO.Socket? _socket;
  final StreamController<String> _socketResponseController =
      StreamController<String>();

  // Stream for listening to socket responses
  Stream<String> get socketResponse => _socketResponseController.stream;

  // Initialize the socket connection
  void connectAndListen() {
    if (_socket != null) {
      debugPrint('SOCKET IO ==> Socket is already connected');
      return;
    }

    debugPrint('SOCKET IO ==> Token ${appStore.token}');

    // Create and configure the socket instance
    _socket = IO.io(
        domainUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Use WebSocket for Flutter
            .setAuth({'token': appStore.token}).build());

    // Handle socket connection events
    _socket?.onConnect((_) {
      debugPrint('SOCKET IO ==> Socket connected');
    });

    _socket?.on('notification', (data) {
      debugPrint('SOCKET IO ==> Data received from socket: $data');
      _socketResponseController.add(data.toString());
      NotificationManager().showNotification(data['title'], data['message']);
    });

    _socket
        ?.onDisconnect((_) => debugPrint('SOCKET IO ==> Socket disconnected'));

    // Handle other events if necessary
    _socket?.on('notification', (data) {
      debugPrint('SOCKET IO ==> Received from server: $data');
    });
  }

  // Update extra headers for the socket
  void updateExtraHeaders(Map<String, String> headers) {
    if (_socket != null) {
      _socket?.io.options?['extraHeaders'] = headers;
      _socket?.disconnect();
      _socket?.connect();
      debugPrint('SOCKET IO ==> Socket headers updated and socket reconnected');
    }
  }

  // Dispose of resources
  void dispose() {
    _socketResponseController.close();
    _socket?.disconnect();
    _socket = null; // Reset the socket to allow reconnection if needed
    debugPrint('SOCKET IO ==> Socket and StreamController disposed');
  }
}

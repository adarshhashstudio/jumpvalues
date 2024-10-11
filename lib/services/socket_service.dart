import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/services/notification_service.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;

class SocketAndNotifications {
  // Factory constructor to return the singleton instance
  factory SocketAndNotifications() => _instance;

  // Private constructor for internal use
  SocketAndNotifications._internal();

  // Singleton instance
  static final SocketAndNotifications _instance =
      SocketAndNotifications._internal();

  socket_io_client.Socket? _socket;
  final StreamController<String> _socketResponseController = StreamController<
      String>.broadcast(); // Use broadcast for multiple listeners

  bool _isConnecting = false; // Flag to prevent multiple connection attempts
  bool _isConnected = false; // Flag to track connection status

  // Stream for listening to socket responses
  Stream<String> get socketResponse => _socketResponseController.stream;

  // Initialize the socket connection
  Future<void> connectAndListen() async {
    if (_isConnecting) {
      debugPrint('SOCKET IO ==> Connection attempt already in progress.');
      return;
    }

    if (_isConnected) {
      debugPrint('SOCKET IO ==> Socket is already connected.');
      return;
    }

    _isConnecting = true;

    debugPrint(
        'SOCKET IO ==> Attempting to connect with Token: ${appStore.token}');

    // Create and configure the socket instance with new token
    _socket = socket_io_client.io(
      domainUrl,
      socket_io_client.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket for Flutter
          .disableAutoConnect() // Disable auto-connection to manage it manually
          .setAuth({'token': appStore.token})
          .enableReconnection() // Disable automatic reconnection
          .build(),
    );

    // Attach event handlers before connecting
    _socket?.onConnect((_) {
      _isConnected = true;
      _isConnecting = false;
      debugPrint('SOCKET IO ==> Socket connected');
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      _isConnecting = false;
      debugPrint('SOCKET IO ==> Socket disconnected');
    });

    _socket?.on('notification', (data) {
      debugPrint(
          'SOCKET IO ==> Data received from socket (notification): $data');
      _socketResponseController.add(data.toString());
      NotificationManager().showNotification(data['title'], data['message']);
    });

    _socket?.on('account_upgraded', (data) {
      debugPrint(
          'SOCKET IO ==> Data received from socket (account_upgraded): $data');
      tokenExpired(NavigationService.navigatorKey.currentState!.context);
    });

    // Connect the socket manually
    _socket?.connect();
  }

  // Clear socket state (disconnect and set it to null)
  void clearSocket() {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.destroy(); // Fully destroy the socket
      _socket = null; // Reset the socket to null to ensure reconnection
      _isConnected = false;
      _isConnecting = false;
      debugPrint('SOCKET IO ==> Socket cleared and destroyed');
    }
  }

  // Dispose of resources
  void dispose() {
    debugPrint('SOCKET IO ==> Disposing socket and stream');
    clearSocket(); // Ensure socket is cleared
    _socketResponseController.close();
    debugPrint('SOCKET IO ==> Socket and StreamController disposed');
  }

  // Function to reset the singleton instance (if needed)
  static void resetInstance() {
    _instance.clearSocket(); // Fully clear the socket on reset
  }
}

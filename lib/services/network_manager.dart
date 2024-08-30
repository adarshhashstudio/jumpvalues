import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/utils/utils.dart';

class NetworkManager {
  // Private constructor
  NetworkManager._internal();

  // Factory constructor to return the singleton instance
  factory NetworkManager() => _instance;
  // Singleton instance
  static final NetworkManager _instance = NetworkManager._internal();

  // Connectivity subscription
  ConnectivityResult? _lastResult;
  late final Connectivity _connectivity;

  // Initialize the connectivity and set up the listener
  void initialize() {
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen(_checkConnectivity);
  }

  // Method to check current connectivity and show/hide Snackbar
  void _checkConnectivity(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _showSnackbar();
    } else if (_lastResult == ConnectivityResult.none &&
        result != ConnectivityResult.none) {
      _hideSnackbar();
    }
    _lastResult = result;
  }

  // Method to show Snackbar
  void _showSnackbar() {
    SnackBarHelper.showStatusSnackBar(
        NavigationService.navigatorKey.currentState!.context,
        StatusIndicator.error,
        'No network connection. Waiting for connection...',
        duration: const Duration(days: 1));
  }

  // Method to hide Snackbar
  void _hideSnackbar() {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentState!.context)
        .hideCurrentSnackBar();
    SnackBarHelper.showStatusSnackBar(
        NavigationService.navigatorKey.currentState!.context,
        StatusIndicator.success,
        'Network Available');
  }
}

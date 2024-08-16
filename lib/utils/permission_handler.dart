import 'package:flutter/material.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  // Request permissions for nearby devices, microphone, and camera
  static Future<bool> requestNearbyDevicesPermissions(
      BuildContext context) async {
    var micAndCameraGranted = await _arePermissionsGranted();

    if (!micAndCameraGranted) {
      micAndCameraGranted = await _requestPermissions();
    }

    if (!micAndCameraGranted) {
      _showPermissionDialog(context);
    }

    return micAndCameraGranted;
  }

  static Future<bool> _arePermissionsGranted() async {
    final micStatus = await Permission.microphone.status;
    final cameraStatus = await Permission.camera.status;
    return micStatus.isGranted && cameraStatus.isGranted;
  }

  static Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();

    return !statuses.values.any((status) => status != PermissionStatus.granted);
  }

  static void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'The app requires access to the camera and microphone. Please enable these permissions manually from your device settings.\n\n'
          'To do this, go to Settings > Apps > $APP_NAME > Permissions and allow access to the Camera and Microphone.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}

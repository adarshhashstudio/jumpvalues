import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  // Request permissions for nearby devices, microphone, and camera
  static Future<bool> requestNearbyDevicesPermissions() async {
    // // Check if all Bluetooth permissions are granted
    // var bluetoothGranted = !(await Future.wait([
    //   Permission.bluetooth.isGranted,
    //   Permission.bluetoothAdvertise.isGranted,
    //   Permission.bluetoothConnect.isGranted,
    //   Permission.bluetoothScan.isGranted,
    // ]))
    //     .any((element) => element == false);

    // // Request Bluetooth permissions if not granted
    // if (!bluetoothGranted) {
    //   var statuses = await [
    //     Permission.bluetooth,
    //     Permission.bluetoothAdvertise,
    //     Permission.bluetoothConnect,
    //     Permission.bluetoothScan,
    //   ].request();

    //   bluetoothGranted =
    //       !statuses.values.any((status) => status != PermissionStatus.granted);
    // }

    // Request permission for nearby WiFi devices (Android 12+)
    // var nearbyWifiDevicesStatus = await Permission.nearbyWifiDevices.request();
    // var nearbyWifiDevicesGranted =
    //     nearbyWifiDevicesStatus == PermissionStatus.granted;

    // Request microphone and camera permissions
    var micAndCameraGranted = !(await Future.wait([
      Permission.microphone.isGranted,
      Permission.camera.isGranted,
    ]))
        .any((element) => element == false);

    if (!micAndCameraGranted) {
      var micAndCameraStatuses = await [
        Permission.microphone,
        Permission.camera,
      ].request();

      micAndCameraGranted = !micAndCameraStatuses.values
          .any((status) => status != PermissionStatus.granted);
    }

    // Return true if all permissions are granted // bluetoothGranted && nearbyWifiDevicesGranted &&
    return  micAndCameraGranted;
  }

  // // Optional: Request location permissions (if needed)
  // static Future<bool> requestLocationPermissions() async {
  //   if (!(await Permission.location.isGranted)) {
  //     await Permission.location.request();
  //   }

  //   bool serviceEnabled = await Permission.location.serviceStatus.isEnabled;
  //   if (!serviceEnabled) {
  //     serviceEnabled = await Location.instance.requestService();
  //   }

  //   return serviceEnabled;
  // }

  // Optional: Request external storage permissions (if needed)
  // static Future<bool> requestStoragePermissions() async {
  //   if (!(await Permission.storage.isGranted)) {
  //     await Permission.storage.request();
  //   }

  //   return await Permission.storage.isGranted;
  // }
}

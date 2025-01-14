import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jumpvalues/screens/splash_screen.dart';
import 'package:jumpvalues/store/app_store.dart';
import 'package:jumpvalues/store/goals_data_hive.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

AppStore appStore = AppStore();
late Box<GoalsData> goalsBox;

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDLkgae9qZezwFRfeU8PcDf1s9DLHKi7mk',
        appId: '1:927941200379:android:8cd86db678ad12b734235e',
        messagingSenderId: '927941200379',
        projectId: 'jumpcc-app',
      ),
    );

    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      FlutterError.dumpErrorToConsole(errorDetails);
      logErrorToFile(errorDetails.exceptionAsString(),
          errorDetails.stack ?? StackTrace.empty);
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      FirebaseCrashlytics.instance
          .log('Flutter error occurred: ${errorDetails.exceptionAsString()}');
      FirebaseCrashlytics.instance.setCustomKey('Error Type', 'Flutter');
      FirebaseCrashlytics.instance
          .setCustomKey('Error Message', errorDetails.exceptionAsString());
      FirebaseCrashlytics.instance
          .setCustomKey('Stack Trace', errorDetails.stack.toString());
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      FirebaseCrashlytics.instance.log('Platform error occurred: $error');
      FirebaseCrashlytics.instance.setCustomKey('Error Type', 'Platform');
      FirebaseCrashlytics.instance
          .setCustomKey('Error Message', error.toString());
      FirebaseCrashlytics.instance
          .setCustomKey('Stack Trace', stack.toString());
      return true;
    };

    await FirebaseCrashlytics.instance.setCustomKey('App Version', '1.0.0');
    await FirebaseCrashlytics.instance.setCustomKey('Build Number', '1');
    await FirebaseCrashlytics.instance
        .log('Firebase and Crashlytics initialized');
  }

  await initialize();

  var isLoggedIn = getBoolAsync(IS_LOGGED_IN);
  await appStore.setLoggedIn(isLoggedIn, isInitializing: true);

  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setUserFirstName(getStringAsync(USER_FIRST_NAME),
        isInitializing: true);
    await appStore.setUserLastName(getStringAsync(USER_LAST_NAME),
        isInitializing: true);
    await appStore.setAdditionalSponsor(getStringAsync(ADDITIONAL_SPONSOR),
        isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL),
        isInitializing: true);
    await appStore.setUserContactNumber(getStringAsync(USER_CONTACT_NUMBER),
        isInitializing: true);
    await appStore.setUserPosition(getStringAsync(USER_POSITION),
        isInitializing: true);
    await appStore.setUserAboutMe(getStringAsync(USER_ABOUT_ME),
        isInitializing: true);
    await appStore.setUserProfilePic(getStringAsync(PROFILE_IMAGE),
        isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    await appStore.setUserType(getStringAsync(USER_TYPE), isInitializing: true);
  }

  await Hive.initFlutter();
  Hive.registerAdapter(GoalsDataAdapter());
  goalsBox = await Hive.openBox<GoalsData>('goalsBox');

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((v) {
    // Catch errors in non-Flutter zones
    runZonedGuarded(() async {
      runApp(const MyApp());
    }, (error, stackTrace) {
      logErrorToFile(error.toString(), stackTrace);
    });
  });
}

Future<void> logErrorToFile(String error, StackTrace stackTrace) async {
  try {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final logFilePath = '${directory.path}/error_logs.txt';

    // Create the log file if it doesn't exist
    final logFile = File(logFilePath);
    if (!await logFile.exists()) {
      await logFile.create();
    }

    // Append the error log to the file
    final logEntry = '''
    --- Error Log ---
    Time: ${DateTime.now()}
    Error: $error
    StackTrace: $stackTrace
    -----------------
    ''';
    debugPrint('--- Error Log ---');
    debugPrint('File Location: $logFilePath');
    debugPrint('Time: ${DateTime.now()}');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
    debugPrint('-----------------');
    await logFile.writeAsString(logEntry, mode: FileMode.append);
    await downloadLogFile();
    await initNotifications();
    await shareErrorLog();
  } catch (e) {
    debugPrint('Failed to write error log: $e');
  }
}

Future<void> initNotifications() async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettingsDarwin = DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      downloadLogFile();
    },
  );
}

Future<void> downloadLogFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final logFilePath = '${directory.path}/error_logs.txt';

    final logFile = File(logFilePath);
    if (await logFile.exists()) {
      // Code to trigger file download for the user
      // For Android/iOS, use share_plus or open_file_plus packages
      await OpenFile.open(logFilePath);
      debugPrint('Log file path: $logFilePath');
      // Example: Share the log file
      // await Share.shareFiles([logFilePath], text: 'Error Logs');
    } else {
      debugPrint('No log file found.');
    }
  } catch (e) {
    debugPrint('Failed to download log file: $e');
  }
}

Future<void> shareErrorLog() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final logFilePath = '${directory.path}/error_logs.txt';

    // Check if the file exists
    final logFile = File(logFilePath);
    if (await logFile.exists()) {
      // Share or download the file (e.g., using the share_plus package)
      // Example with share_plus:
      // Share the file
      await Share.shareXFiles(
        [XFile(logFile.path)],
        text: 'Crash Logs',
      );
      debugPrint('Log file ready for download: $logFilePath');
    } else {
      debugPrint('No error log file found.');
    }
  } catch (e) {
    debugPrint('Failed to share error log: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // NetworkManager().initialize(); // For Network check socket - Singleton class
  }

  @override
  Widget build(BuildContext context) => RestartAppWidget(
        child: Observer(
          builder: (_) => MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            title: APP_NAME,
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                primary: primaryColor,
                secondary: secondaryColor,
              ),
              textTheme: const TextTheme(
                labelLarge: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.white,
                ),
                labelMedium: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0.07,
                ),
              ),
            ),
            home: const SplashScreen(),
          ),
        ),
      );
}

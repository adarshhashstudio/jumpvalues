import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jumpvalues/screens/splash_screen.dart';
import 'package:jumpvalues/store/app_store.dart';
import 'package:jumpvalues/store/goals_data_hive.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

AppStore appStore = AppStore();
late Box<GoalsData> goalsBox;

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDLkgae9qZezwFRfeU8PcDf1s9DLHKi7mk',
      appId: '1:927941200379:android:8cd86db678ad12b734235e',
      messagingSenderId: '927941200379',
      projectId: 'jumpcc-app',
    ),
  );

  FlutterError.onError = (FlutterErrorDetails errorDetails) {
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
    FirebaseCrashlytics.instance.setCustomKey('Stack Trace', stack.toString());
    return true;
  };

  await FirebaseCrashlytics.instance.setCustomKey('App Version', '1.0.0');
  await FirebaseCrashlytics.instance.setCustomKey('Build Number', '1');
  await FirebaseCrashlytics.instance
      .log('Firebase and Crashlytics initialized');

  await initialize();

  var isLoggedIn = getBoolAsync(IS_LOGGED_IN);
  await appStore.setLoggedIn(isLoggedIn, isInitializing: true);

  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME),
        isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL),
        isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER),
        isInitializing: true);
    await appStore.setUserCompany(getStringAsync(USER_COMPANY),
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

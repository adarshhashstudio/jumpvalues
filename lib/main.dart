import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jumpvalues/screens/splash_screen.dart';
import 'package:jumpvalues/store/app_store.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

AppStore appStore = AppStore();

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBg3DW6PG-UgfUkFB0WKurkkpXGzdS5HkE',
    appId: '1:36694481587:android:9676cd788ef2d9dc7eaec6',
    messagingSenderId: '36694481587',
    projectId: 'jumpcc-8634f',
  ));

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
                )),
      );
}

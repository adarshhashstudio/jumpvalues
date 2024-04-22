import 'package:flutter/material.dart';
import 'package:jumpvalues/common.dart';
import 'package:jumpvalues/screens/splash_screen.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
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
      );
}

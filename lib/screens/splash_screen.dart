import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/network/firebase_apis.dart';
import 'package:jumpvalues/screens/dashboard/dashboard.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkTokenAndNavigate();

    initializeNotifications();
    super.initState();
  }

  void initializeNotifications() async {
    if (Platform.isAndroid) {
      await FirebaseApi().initNotifications();
    } else {
      return;
    }
  }

  void checkTokenAndNavigate() async {
    if (appStore.isLoggedIn) {
      // Token exists, navigate to Dashboard
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      });
    } else {
      // Token doesn't exist, navigate to WelcomeScreen after a delay
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Image.asset(
              'assets/images/blue_jump.png',
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ),
      );
}

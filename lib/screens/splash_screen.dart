import 'package:flutter/material.dart';
import 'package:jumpvalues/screens/dashbaord.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkTokenAndNavigate();
    super.initState();
  }

  void checkTokenAndNavigate() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      // Token exists, navigate to Dashboard
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
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

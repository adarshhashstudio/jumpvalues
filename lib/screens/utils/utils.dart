import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:nb_utils/nb_utils.dart';

enum StatusIndicator { warning, error, success }

Color successColor = const Color(0xFF73C322);
Color errorColor = const Color(0xFFD4111B);
Color warningColor = const Color(0xFFFFAB1A);

const domainUrl = 'http://18.209.192.96:8080'; // 'http://13.234.173.125:6060';
const baseUrl = '$domainUrl/';
const webViewUrl = 'http://18.209.192.96/pages/';

const aboutUsUrl = '${webViewUrl}about-us.html';
const contactUsUrl = '${webViewUrl}contact-us.html';
const termsAndPrivacyUrl = '${webViewUrl}privacy.html';
const learnSectionUrl = '${webViewUrl}our-values.html';

String? validateEmail(String email) {
  if (RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    return null;
  } else {
    return 'Invalid Email';
  }
}

String? passwordValidate(String password) {
  // Check if password length is more than 6 characters
  if (password.length <= 8) {
    return 'Password should be atleast of 8 characters';
  }

  // Check if password contains at least one capital letter
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one capital letter';
  }

  // Check if password contains at least one digit
  if (!password.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one digit';
  }

  // Check if password contains at least one special character
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character';
  }

  // Password meets all criteria
  return null;
}

class SnackBarHelper {
  static void showStatusSnackBar(
      BuildContext context, StatusIndicator status, String text) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case StatusIndicator.warning:
        backgroundColor = warningColor;
        break;
      case StatusIndicator.error:
        backgroundColor = errorColor;
        break;
      case StatusIndicator.success:
        backgroundColor = successColor;
        break;
    }

    textColor = Colors.white;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: backgroundColor,
        content: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

void isTokenAvailable(BuildContext context) async {
  if (!appStore.isLoggedIn) {
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (Route<dynamic> route) => false);
  }
}

void tokenExpired(BuildContext context) async {
  await appStore.clearData();
  isTokenAvailable(context);
}

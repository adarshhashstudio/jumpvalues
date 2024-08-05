import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/utils/configs.dart';

enum StatusIndicator { warning, error, success }

enum SessionStatus {
  pending,
  accepted,
  rejected,
  inProgress,
  completed,
  expired,
}

void hideAppKeyboard(context) =>
    FocusScope.of(context).requestFocus(FocusNode());

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
        duration: const Duration(seconds: 3),
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

// Define colors for each status
const Map<SessionStatus, Color> statusColors = {
  SessionStatus.pending: Color(0xFFEA2F2F),
  SessionStatus.accepted: Color(0xFF00968A),
  SessionStatus.inProgress: Color(0xFFB953C0),
  SessionStatus.rejected: Color(0xFF8D0E06),
  SessionStatus.completed: Color(0xFF3CAE5C),
  SessionStatus.expired: Color(0xFFC41520),
};

// Define display names for each status
const Map<SessionStatus, String> statusDisplayNames = {
  SessionStatus.pending: 'Pending',
  SessionStatus.accepted: 'Accepted',
  SessionStatus.inProgress: 'In Progress',
  SessionStatus.rejected: 'Rejected',
  SessionStatus.completed: 'Completed',
  SessionStatus.expired: 'Expired',
};

Color getColorByStatus(SessionStatus status) =>
    statusColors[status] ?? Colors.grey;

String getNameByStatus(SessionStatus status) =>
    statusDisplayNames[status] ?? 'Unknown';

class Debouncer {
  Debouncer({required this.milliseconds});
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

/// Common method to format DateTime to 'yyyy/MM/dd'
///
/// 2024-08-05 13:00:00.000 -> 2024/08/02
String formatDate(DateTime dateTime) =>
    DateFormat('yyyy/MM/dd').format(dateTime);

/// Common method to format DateTime to 'HH:mm'
///
/// 2024-08-05 13:00:00.000 -> 13:00
String formatTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/store/goals_store.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum StatusIndicator { warning, error, success }

enum SessionStatus {
  all,
  pending,
  accepted,
  rejected,
  waiting,
  waitingInProgress,
  completed,
  expired,
  abandoned,
}

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
      BuildContext context, StatusIndicator status, String text,
      {Duration duration = const Duration(seconds: 3)}) {
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
        duration: duration,
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
  GoalsStore(goalsBox, ''); // Clear the userId on logout
  isTokenAvailable(context);
}

const Map<SessionStatus, Color> statusColors = {
  SessionStatus.pending: Color(0xFFEA2F2F),
  SessionStatus.accepted: Color(0xFF00968A),
  SessionStatus.waitingInProgress: Color(0xFFB953C0),
  SessionStatus.rejected: Color(0xFF8D0E06),
  SessionStatus.completed: Color(0xFF3CAE5C),
  SessionStatus.expired: Color(0xFFC41520),
  SessionStatus.waiting: Color(0xFF1E88E5),
  SessionStatus.abandoned: Color(0xFF9E9E9E),
};

const Map<SessionStatus, String> statusDisplayNames = {
  SessionStatus.all: 'All',
  SessionStatus.pending: 'Pending',
  SessionStatus.accepted: 'Accepted',
  SessionStatus.waitingInProgress: 'In Progress',
  SessionStatus.rejected: 'Rejected',
  SessionStatus.completed: 'Completed',
  SessionStatus.expired: 'Expired',
  SessionStatus.waiting: 'Booked',
  SessionStatus.abandoned: 'Abandoned',
};

const Map<SessionStatus, int> sessionStatusCodes = {
  SessionStatus.all: -1,
  SessionStatus.pending: 0,
  SessionStatus.accepted: 1,
  SessionStatus.waitingInProgress: 4,
  SessionStatus.rejected: 2,
  SessionStatus.completed: 5,
  SessionStatus.expired: 6,
  SessionStatus.waiting: 3,
  SessionStatus.abandoned: 7,
};

const Map<int, SessionStatus> sessionStatusFromCodes = {
  -1: SessionStatus.all,
  0: SessionStatus.pending,
  1: SessionStatus.accepted,
  4: SessionStatus.waitingInProgress,
  2: SessionStatus.rejected,
  5: SessionStatus.completed,
  6: SessionStatus.expired,
  3: SessionStatus.waiting,
  7: SessionStatus.abandoned,
};

Color getColorByStatus(SessionStatus status) =>
    statusColors[status] ?? Colors.grey;

String getNameByStatus(SessionStatus status) =>
    statusDisplayNames[status] ?? 'Unknown';

int getSessionStatusCode(SessionStatus status) =>
    sessionStatusCodes[status] ?? -1;

SessionStatus getSessionStatusFromCode(int statusCode) =>
    sessionStatusFromCodes[statusCode] ?? SessionStatus.all;

// class Debouncer {
//   Debouncer({required this.milliseconds});
//   final int milliseconds;
//   VoidCallback? action;
//   Timer? _timer;

//   run(VoidCallback action) {
//     if (_timer != null) {
//       _timer!.cancel();
//     }
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }

/// Common method to format DateTime to 'yyyy/MM/dd'
///
/// 2024-08-05 13:00:00.000 -> 2024/08/02
String formatDate(DateTime dateTime) =>
    DateFormat('yyyy/MM/dd').format(dateTime);

/// Common method to format DateTime to 'HH:mm'
///
/// 2024-08-05 13:00:00.000 -> 13:00
String formatTimeCustom(DateTime dateTime) =>
    DateFormat('HH:mm').format(dateTime);

String formatDateTimeCustom(String date, String time) {
  // Combine date and time strings into a single DateTime object
  var dateTime = DateTime.parse('$date $time');

  // Format DateTime into the desired format: MM/DD/YYYY hh:mm AM/PM
  var formattedDateTime = DateFormat('MM/dd/yyyy hh:mm a').format(dateTime);

  return formattedDateTime;
}

String getImageUrl(String? imageUrl) => '$domainUrl/${imageUrl ?? ''}';

var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

String numberToMaskedText(String number) {
  // Apply the mask (###) ###-#### to the first 10 digits
  final buffer = StringBuffer();

  if (number.isNotEmpty) {
    buffer.write('(');
    buffer.write(number.substring(0, number.length < 3 ? number.length : 3));
    buffer.write(')');
  }

  if (number.length > 3) {
    buffer.write(' ');
    buffer.write(number.substring(3, number.length < 6 ? number.length : 6));
  }

  if (number.length > 6) {
    buffer.write('-');
    buffer.write(number.substring(6, number.length < 10 ? number.length : 10));
  }

  if (number.length > 10) {
    buffer.write(number.substring(10));
  }

  return buffer.toString();
}

String maskedTextToNumber(String maskedText) {
  // Use RegExp to remove all non-numeric characters
  final plainNumber = maskedText.replaceAll(RegExp(r'[^0-9]'), '');

  return plainNumber;
}

class DateTimeUtils {
  /// Converts an ISO 8601 date string to the format `MM/DD/YYYY hh:mm AM/PM`.
  ///
  /// - [isoDate]: The ISO 8601 date string.
  ///
  /// Returns a formatted date string.
  static String formatToUSDateTime(String isoDate) {
    try {
      // Parse the ISO date string to a DateTime object and convert to local time
      var dateTime = DateTime.parse(isoDate).toLocal();

      // Format the DateTime object to the desired format
      return DateFormat('MM/dd/yyyy hh:mm a').format(dateTime);
    } catch (e) {
      // If parsing or formatting fails, print an error and return an empty string
      debugPrint('Error formatting date: $e');
      return '';
    }
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

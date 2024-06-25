import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

Color primaryColor = const Color(0xFF5ca2db);
Color secondaryColor = const Color(0xFFE9ECF1);
Color disableColor = const Color(0xffacacac);
Color hintColor = const Color(0xFF9BA9B1);
Color textColor = const Color(0xff0C0C0C);

String welcomeImage = 'assets/images/welcome.svg';
String editImage = 'assets/images/edit.png';
String learnImage = 'assets/images/learn.png';
String selectImage = 'assets/images/select.png';

void hideAppKeyboard(context) =>
    FocusScope.of(context).requestFocus(FocusNode());

Widget labelContainer(
        {bool isLabel = true,
        bool isError = false,
        required String label,
        required double width,
        required double height,
        Color? color,
        void Function()? onTap,
        BorderRadiusGeometry? borderRadius,
        EdgeInsetsGeometry? padding,
        AlignmentGeometry alignment = Alignment.center,
        double? labelContainerSpace = 16,
        String? text,
        Widget? child}) =>
    Column(
      children: [
        if (isLabel)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (isLabel)
          SizedBox(
            height: labelContainerSpace,
          ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              color: color ?? secondaryColor,
              border: isError
                  ? Border.all(color: Colors.red)
                  : Border.all(
                      color: color ?? secondaryColor,
                    ),
            ),
            child: Align(
                alignment: alignment,
                child: (text != null)
                    ? Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : child),
          ),
        ),
      ],
    );

Widget textFormField({
  void Function(String)? onChanged,
  void Function(bool)? unHidePassword,
  TextInputType? keyboardType,
  bool isLabel = true,
  int? maxLength,
  String? hintText,
  FocusNode? focusNode,
  bool autofocus = false,
  Widget? suffix,
  int? maxLines = 1,
  TextInputAction? textInputAction,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  TextEditingController? controller,
  bool obscureText = false,
  Widget? prefixIcon,
  double borderRadius = 20,
  String? errorText,
  double labelTextBoxSpace = 16,
  required String label,
  bool isPassword = false, // New parameter to control password field
}) =>
    Column(
      children: [
        if (isLabel)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (isLabel)
          SizedBox(
            height: labelTextBoxSpace,
          ),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              TextFormField(
            focusNode: focusNode,
            controller: controller,
            validator: validator,
            maxLength: maxLength,
            onChanged: onChanged,
            keyboardType: keyboardType,
            autofocus: autofocus,
            cursorColor: Colors.grey,
            obscureText: isPassword ? obscureText : false,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            maxLines: maxLines,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: hintText,
              hintStyle: TextStyle(
                color: hintColor,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: secondaryColor),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              filled: true,
              errorText: errorText,
              errorStyle: const TextStyle(color: Color(0xffff3333)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: primaryColor),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xffff3333)),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xffff3333)),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: secondaryColor),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              fillColor: secondaryColor,
              focusColor: secondaryColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: maxLines! > 1 ? 10 : 0,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: () {
                        unHidePassword!(obscureText);
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )
                  : suffix,
              prefixIcon: prefixIcon,
            ),
          ),
        ),
      ],
    );

Widget intlPhoneField({
  void Function(PhoneNumber)? onChanged,
  FutureOr<String?> Function(PhoneNumber?)? validator,
  TextEditingController? controller,
  FocusNode? focusNode,
  bool autofocus = false,
  String initialCountryCode = 'IN',
  String label = 'Phone Number',
  double borderRadius = 20,
  bool isLabel = true,
}) =>
    Column(
      children: [
        if (isLabel)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (isLabel)
          const SizedBox(
            height: 16,
          ),
        IntlPhoneField(
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          autofocus: autofocus,
          initialCountryCode: initialCountryCode,
          decoration: InputDecoration(
            counterText: '',
            hintText: 'Enter Phone Number',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            filled: true,
            errorStyle: const TextStyle(color: Color(0xffff3333)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xffff3333)),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xffff3333)),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            fillColor: secondaryColor,
            focusColor: secondaryColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 0,
            ),
          ),
        ),
      ],
    );

Widget button(
  BuildContext context, {
  required void Function()? onPressed,
  bool isLoading = false,
  String? text,
  bool isEnabled = true,
  bool isBordered = false,
}) =>
    ElevatedButton(
      style: ButtonStyle(
        backgroundColor: isBordered
            ? WidgetStateProperty.all(isEnabled
                ? Theme.of(context).scaffoldBackgroundColor
                : disableColor)
            : WidgetStateProperty.all(isEnabled
                ? Theme.of(context).colorScheme.primary
                : disableColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: isBordered
                ? BorderSide(color: Theme.of(context).primaryColor)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: SizedBox(
        height: 50,
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                  ),
                )
              : Text(
                  text ?? '',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isBordered
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.labelLarge?.color),
                ),
        ),
      ),
    );

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color primaryColor = const Color(0xFF5ca2db);
Color secondaryColor = const Color(0xFFE9ECF1);
Color disableColor = const Color(0xffacacac);
Color hintColor = const Color(0xFF9BA9B1);
Color textColor = const Color(0xff0C0C0C);

String welcomeImage = 'assets/images/welcome.svg';

void hideAppKeyboard(context) =>
    FocusScope.of(context).requestFocus(FocusNode());

Widget textFormField(
        {void Function(String)? onChanged,
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
        required String label}) =>
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
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          maxLength: maxLength,
          onChanged: onChanged,
          keyboardType: keyboardType,
          autofocus: autofocus,
          cursorColor: Colors.grey,
          obscureText: obscureText,
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
                  borderRadius: BorderRadius.circular(borderRadius)),
              filled: true,
              errorStyle: const TextStyle(color: Color(0xffff3333)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: primaryColor),
                  borderRadius: BorderRadius.circular(borderRadius)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Color(0xffff3333)),
                  borderRadius: BorderRadius.circular(borderRadius)),
              errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Color(0xffff3333)),
                  borderRadius: BorderRadius.circular(borderRadius)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: secondaryColor),
                  borderRadius: BorderRadius.circular(borderRadius)),
              fillColor: secondaryColor,
              focusColor: secondaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: maxLines! > 1 ? 10 : 0),
              suffixIcon: suffix,
              prefixIcon: prefixIcon),
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
            ? MaterialStateProperty.all(isEnabled
                ? Theme.of(context).scaffoldBackgroundColor
                : disableColor)
            : MaterialStateProperty.all(isEnabled
                ? Theme.of(context).colorScheme.primary
                : disableColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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

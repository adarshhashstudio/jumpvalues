import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonWidgets {
  static PreferredSizeWidget appBar(
          {BuildContext? context,
          Widget? leading,
          double? leadingWidth,
          String? title,
          bool backWidget = false,
          bool bottomLine = false,
          Widget leadingWidget = const SizedBox(),
          List<Widget>? actions}) =>
      AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        bottom: backWidget
            ? bottomLine
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(4.0),
                    child: Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                  )
                : null
            : null,
        leading: backWidget
            ? IconButton(
                onPressed: () {
                  Navigator.of(context!).pop();
                },
                icon: const Icon(Icons.arrow_back_ios),
              )
            : leadingWidget,
        leadingWidth: backWidget ? null : 0,
        title: Text(
          title.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 21,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        actions: actions,
      );

  static double appBarHeight = CommonWidgets.appBar().preferredSize.height;
}

Widget placeHolderWidget(
        {String? placeHolderImage,
        double? height,
        double? width,
        BoxFit? fit,
        AlignmentGeometry? alignment}) =>
    PlaceHolderWidget(
      height: height,
      width: width,
      alignment: alignment ?? Alignment.center,
    );

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

Widget divider() => const Divider(
      height: 0,
      color: Colors.black12,
    );

void showRatingDialog(BuildContext context,
    {void Function()? onTapRateNow,
    void Function()? onTapMaybeLater,
    bool isShortDialogue = false}) {
  var messageController = TextEditingController();
  var rating = 3.0;
  var rateLoading = false;

  var maybeLaterButton = InkWell(
    onTap: () {
      if (onTapMaybeLater != null) {
        onTapMaybeLater();
      } else {
        // exit(0);
        Navigator.of(context).pop();
      }
    },
    child: Text(
      'Cancel',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          fontSize: 13),
    ).center(),
  );

  var alertDialog = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: Theme.of(context).colorScheme.background,
    shadowColor: Theme.of(context).colorScheme.background,
    surfaceTintColor: Theme.of(context).colorScheme.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
    title: Text(
      'Your opinion matters to us',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: 18,
          color: Theme.of(context).brightness == Brightness.light
              ? textColor
              : secondaryColor),
    ).center(),
    content: StatefulBuilder(
        builder: (context, setState) => Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    20.height,
                    Text(
                      'How was your experience?',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 14,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? textColor
                                  : secondaryColor),
                    ),
                    if (!isShortDialogue) 10.height,
                    if (!isShortDialogue)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.62,
                        child: RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rate) {
                            rating = rate;
                          },
                        ),
                      ),
                    if (!isShortDialogue) 16.height,
                    if (!isShortDialogue)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.62,
                        child: Center(
                          child: textFormField(
                            controller: messageController,
                            hintText: 'Leave Message',
                            label: '',
                            isLabel: false,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    20.height,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.62,
                      child: AppButton(
                        onTap: () async {
                          hideKeyboard(context);
                          setState(() {
                            rateLoading = true;
                          });
                          await Future.delayed(const Duration(seconds: 1))
                              .then((v) {
                            setState(() {
                              rateLoading = false;
                            });
                            Navigator.of(context).pop();
                          });
                        },
                        text: 'Rate Now',
                        child: rateLoading
                            ? Transform.scale(
                                scale: 0.6,
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ).center(),
                              )
                            : null,
                      ),
                    ),
                    20.height,
                  ],
                ),
              ),
            )),
    actions: [
      maybeLaterButton,
    ],
  );

  showDialog(
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) => alertDialog,
  );
}

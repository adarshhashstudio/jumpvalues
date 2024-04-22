import 'package:flutter/material.dart';

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

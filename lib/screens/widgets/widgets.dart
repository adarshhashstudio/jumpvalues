// Function to show all selected values when the button is clicked
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jumpvalues/screens/utils/common.dart';
import 'package:jumpvalues/screens/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

Widget selectionContainerForAll(BuildContext context,
        {String? heading,
        bool isLoading = false,
        double? spaceBelowTitle,
        BorderRadiusGeometry? borderRadius,
        List<Widget> children = const <Widget>[],
        bool isError = false}) =>
    Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: isError
            ? Border.all(color: Colors.red)
            : Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null)
            Text(
              '$heading${isError ? ' required *' : ''}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isError
                        ? Colors.red
                        : Theme.of(context).textTheme.titleSmall?.color,
                  ),
            ),
          if (heading != null)
            SizedBox(
              height:
                  spaceBelowTitle ?? MediaQuery.of(context).size.height * 0.04,
            ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: children,
                )
        ],
      ),
    );

Widget todaySession(BuildContext context, {required String total}) =>
    GestureDetector(
      onTap: () async {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: boxDecorationDefault(
            borderRadius: radius(), color: context.cardColor),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: boxDecorationDefault(shape: BoxShape.circle),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(icToday, height: 24).paddingAll(5),
                ),
                16.width,
                Text('Today\'s Sessions', style: boldTextStyle()).expand(),
                16.width,
                Text(
                  total,
                  style: primaryTextStyle(
                      color: context.primaryColor,
                      weight: FontWeight.bold,
                      size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );

class TotalWidget extends StatelessWidget {
  final String title;
  final String total;
  final String icon;
  final Color? color;

  TotalWidget(
      {required this.title,
      required this.total,
      required this.icon,
      this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: boxDecorationDefault(color: color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(total.validate(),
                      style: boldTextStyle(color: primaryColor, size: 18),
                      maxLines: 1),
                ),
                Container(
                  decoration: boxDecorationDefault(shape: BoxShape.circle),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    icon,
                    width: 24,
                    height: 24,
                  ).paddingAll(6),
                ),
              ],
            ),
            16.height,
            Text(
              title,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ],
        ),
      );
}

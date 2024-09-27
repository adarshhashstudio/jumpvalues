// Function to show all selected values when the button is clicked
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:jumpvalues/models/available_coaches_response_model.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

Widget selectionContainerForAll(BuildContext context,
        {String? heading,
        bool goToSelectValues = false,
        void Function()? onTap,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$heading${isError ? ' required *' : ''}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isError
                            ? Colors.red
                            : Theme.of(context).textTheme.titleSmall?.color,
                      ),
                ),
                if (goToSelectValues)
                  const Icon(
                    Icons.arrow_right,
                    size: 26,
                  )
              ],
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
    ).onTap(() {
      if (goToSelectValues) {
        if (onTap != null) {
          onTap();
        }
      }
    });

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
                const Text('Today\'s Sessions',
                        style: TextStyle(color: textSecondaryColor))
                    .expand(),
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
  TotalWidget(
      {required this.title,
      required this.total,
      required this.icon,
      this.color});
  final String title;
  final String total;
  final String icon;
  final Color? color;

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
              style: const TextStyle(color: textSecondaryColor),
            ),
          ],
        ),
      );
}

class CoachItemComponent extends StatelessWidget {
  CoachItemComponent({this.coachDetail, this.index, this.onTap});

  final AvailableCoaches? coachDetail;
  final int? index;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        decoration: boxDecorationDefault(
            borderRadius: radius(), color: context.cardColor),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: getImageUrl(coachDetail?.dp),
                      fit: BoxFit.cover,
                      height: 70,
                      width: 70,
                      placeholder: (context, v) => Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${coachDetail?.firstName ?? ''} ${coachDetail?.lastName ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textSecondaryColor,
                          fontSize: 17,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.001,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Years of Experience: ',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textSecondaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: (coachDetail?.experience ?? 0).toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.001,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Total sessions: ',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: textSecondaryColor,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  (coachDetail?.totalSessions ?? 0).toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            buildDescriptionSection(context,
                certificate: coachDetail?.certifications ?? 'N/A',
                philosophy: coachDetail?.philosophy ?? 'N/A',
                rating: coachDetail?.rating),
          ],
        ),
      ).onTap(onTap ?? () {});

  Widget buildDescriptionSection(BuildContext context,
          {String? certificate, String? philosophy, double? rating}) =>
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Total Ratings: ',
                  style: TextStyle(fontSize: 11, color: textSecondaryColor),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                PannableRatingBar.builder(
                  rate: '${rating ?? 0}'.toDouble(),
                  alignment: WrapAlignment.center,
                  spacing: 2,
                  runSpacing: 2,
                  itemCount: 5,
                  direction: Axis.horizontal,
                  itemBuilder: (context, index) => const RatingWidget(
                    selectedColor: Colors.orange,
                    unSelectedColor: Colors.grey,
                    child: Icon(
                      Icons.star,
                      size: 16,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Coaching Certificate',
                    style: TextStyle(color: primaryColor)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Text(
                  certificate ?? 'N/A',
                  style:
                      const TextStyle(fontSize: 12, color: textSecondaryColor),
                  maxLines: 2,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                const Divider(
                    height: 0, color: Color.fromARGB(31, 147, 142, 142)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Coaching Philosophy',
                    style: TextStyle(color: primaryColor)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Text(
                  philosophy ?? 'N/A',
                  style:
                      const TextStyle(fontSize: 12, color: textSecondaryColor),
                  maxLines: 2,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
              ],
            ),
          ],
        ),
      );
}

class CachedImageWidget extends StatelessWidget {
  CachedImageWidget({
    required this.url,
    required this.height,
    required this.width,
    required this.fit,
    required this.radius,
  });
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: radius,
        child: Image.network(
          url,
          height: height,
          width: width,
          fit: fit,
        ),
      );
}

extension WidgetExtensions on Widget {
  Widget onTap(VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: this,
      );
}

/// Default App Button
class AppButton extends StatefulWidget {
  AppButton({
    this.onTap,
    this.text,
    this.width,
    this.color,
    this.textColor,
    this.padding,
    this.margin,
    this.textStyle,
    this.shapeBorder,
    this.child,
    this.elevation,
    this.enabled = true,
    this.height,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.enableScaleAnimation,
    this.disabledTextColor,
    Key? key,
  }) : super(key: key);
  final Function? onTap;
  final String? text;
  final double? width;
  final Color? color;
  final Color? textColor;
  final Color? disabledColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final ShapeBorder? shapeBorder;
  final Widget? child;
  final double? elevation;
  final double? height;
  final bool enabled;
  final bool? enableScaleAnimation;
  final Color? disabledTextColor;

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  AnimationController? _controller;

  @override
  void initState() {
    if (widget.enableScaleAnimation
        .validate(value: enableAppButtonScaleAnimationGlobal)) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: appButtonScaleAnimationDurationGlobal ?? 50,
        ),
        lowerBound: 0.0,
        upperBound: 0.1,
      )..addListener(() {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && widget.enabled) {
      _scale = 1 - _controller!.value;
    }

    if (widget.enableScaleAnimation
        .validate(value: enableAppButtonScaleAnimationGlobal)) {
      return Listener(
        onPointerDown: (details) {
          _controller?.forward();
        },
        onPointerUp: (details) {
          _controller?.reverse();
        },
        child: Transform.scale(
          scale: _scale,
          child: buildButton(),
        ),
      );
    } else {
      return buildButton();
    }
  }

  Widget buildButton() => Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: MaterialButton(
          minWidth: widget.width,
          padding: widget.padding ?? dynamicAppButtonPadding(context),
          onPressed: widget.enabled
              ? widget.onTap != null
                  ? widget.onTap as void Function()?
                  : null
              : null,
          color: widget.color ?? appButtonBackgroundColorGlobal,
          child: widget.child ??
              Text(
                widget.text.validate(),
                style: widget.textStyle ??
                    boldTextStyle(
                      color:
                          widget.textColor ?? defaultAppButtonTextColorGlobal,
                    ),
              ),
          shape: widget.shapeBorder ?? defaultAppButtonShapeBorder,
          elevation: widget.elevation ?? defaultAppButtonElevation,
          animationDuration: const Duration(milliseconds: 300),
          height: widget.height,
          disabledColor: widget.disabledColor,
          focusColor: widget.focusColor,
          hoverColor: widget.hoverColor,
          splashColor: widget.splashColor,
          disabledTextColor: widget.disabledTextColor,
        ),
      );
}

Widget dataNotFoundWidget(BuildContext context,
        {void Function()? onTap, String? text, bool showImage = true}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showImage)
          Image.asset(
            empty,
            width: MediaQuery.of(context).size.width * 0.2,
          ),
        if (showImage)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        Text(
          text ?? 'Data Not Available.',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        if (onTap != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, color: primaryColor).onTap(onTap),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Text(
                'Reload',
                textAlign: TextAlign.center,
                style: boldTextStyle(color: primaryColor),
              ).onTap(onTap),
            ],
          ),
      ],
    ).center();

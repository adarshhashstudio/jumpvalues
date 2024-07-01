// Function to show all selected values when the button is clicked
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/booking_item_model.dart';
import 'package:jumpvalues/models/service_resource.dart';
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

class BookingItemComponent extends StatelessWidget {
  BookingItemComponent({
    required this.showButtons,
    required this.bookingItem,
    this.serviceResource,
    this.index,
  });
  final bool showButtons;
  final BookingItem bookingItem;
  final ServiceResource? serviceResource;
  final int? index;

  @override
  Widget build(BuildContext context) => buildBookingItem(context);

  Widget buildBookingItem(BuildContext context) {
    // Use data from bookingItem instead of dummy data
    var status = serviceResource?.status ?? bookingItem.status ?? 'Unknown';
    SessionStatus sessionStatus;

    if (index == 0) {
      status = 'pending';
      sessionStatus = SessionStatus.pending;
    } else if (index == 1) {
      status = 'pending';
      sessionStatus = SessionStatus.pending;
    } else if (index == 2) {
      status = 'accepted';
      sessionStatus = SessionStatus.accepted;
    } else if (index == 3) {
      status = 'rejected';
      sessionStatus = SessionStatus.rejected;
    } else if (index == 4) {
      status = 'in-progress';
      sessionStatus = SessionStatus.inProgress;
    } else if (index == 5) {
      status = 'in-progress';
      sessionStatus = SessionStatus.inProgress;
    } else if (index == 6) {
      status = 'in-progress';
      sessionStatus = SessionStatus.inProgress;
    } else if (index == 7) {
      status = 'completed';
      sessionStatus = SessionStatus.completed;
    } else if (index == 8) {
      status = 'completed';
      sessionStatus = SessionStatus.completed;
    } else if (index == 9) {
      status = 'completed';
      sessionStatus = SessionStatus.completed;
    } else {
      status = 'expired';
      sessionStatus = SessionStatus.expired;
    }

    var imageUrl = serviceResource?.avatar ??
        bookingItem.imageUrl ??
        'https://picsum.photos/200/300';
    var bookingId = serviceResource?.id ?? bookingItem.bookingId ?? 'N/A';
    var serviceName =
        serviceResource?.firstName ?? bookingItem.serviceName ?? 'Service';
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString() ??
        bookingItem.date ??
        'Date';
    var time =
        DateFormat.jms().format(DateTime.now()) ?? bookingItem.time ?? 'Time';
    var customerName =
        serviceResource?.lastName ?? bookingItem.customerName ?? 'Customer';
    var description = serviceResource?.email ??
        bookingItem.description ??
        'No description available';

    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: boxDecorationDefault(
          borderRadius: radius(), color: context.cardColor),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedImageWidget(
                url: imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: getColorByStatus(sessionStatus)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                getNameByStatus(sessionStatus),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: getColorByStatus(sessionStatus),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '#$bookingId',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$serviceName $customerName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textSecondaryColor,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description.isNotEmpty)
            buildDescriptionSection(
                context, date, time, customerName, description),
          if (showButtons) buildButtons(context, status)
        ],
      ),
    ).onTap(() {
      // Handle tap event
    });
  }

  Widget buildDescriptionSection(
    BuildContext context,
    String date,
    String time,
    String customerName,
    String description,
  ) =>
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Date & Time', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$date At $time',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ).paddingAll(8),
            // if (customerName.isNotEmpty)
            //   Column(
            //     children: [
            //       const Divider(height: 0, color: Colors.black12),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           const Text('Client',
            //               style: TextStyle(color: Colors.grey)),
            //           const SizedBox(width: 8),
            //           Expanded(
            //             child: Text(
            //               customerName,
            //               style: const TextStyle(fontSize: 12),
            //               textAlign: TextAlign.right,
            //             ),
            //           ),
            //         ],
            //       ).paddingAll(8),
            //     ],
            //   ),
            if (description.isNotEmpty)
              Column(
                children: [
                  const Divider(height: 0, color: Colors.black12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remarks',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ).paddingAll(8),
                ],
              ),
          ],
        ),
      );

  Widget buildButtons(BuildContext context, String status) => Row(
        children: [
          if (status == 'pending')
            Row(
              children: [
                if (appStore.userTypeCoach)
                  AppButton(
                    text: 'Decline',
                    textColor: primaryColor,
                    color: white,
                    enabled: true,
                    onTap: () {},
                  ).expand(),
                if (appStore.userTypeCoach)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                AppButton(
                  text: appStore.userTypeCoach ? 'Accept' : 'Pending',
                  textColor: white,
                  color: primaryColor,
                  enabled: true,
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == 'accepted')
            Row(
              children: [
                AppButton(
                  text: 'Accepted',
                  textColor: white,
                  color: primaryColor,
                  enabled: true,
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == 'rejected')
            Row(
              children: [
                AppButton(
                  text: 'Rejected',
                  textColor: Colors.black38,
                  color: Colors.grey.withOpacity(0.5),
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == 'in-progress')
            Row(
              children: [
                AppButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.av_timer,
                        color: white,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                        'In Progress',
                        style: TextStyle(color: white),
                      )
                    ],
                  ),
                  textColor: white,
                  color: primaryColor,
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
        ],
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

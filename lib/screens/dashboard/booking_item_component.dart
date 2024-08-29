import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/requested_sessions_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/video_calling_module/video_call_page.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/permission_handler.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart' as nb;

class BookingItemComponent extends StatefulWidget {
  BookingItemComponent({
    required this.showButtons,
    this.serviceResource,
    this.index,
    required this.onActionPerformed,
  });
  final bool showButtons;
  final RequestedSession? serviceResource;
  final int? index;
  final VoidCallback onActionPerformed;

  @override
  State<BookingItemComponent> createState() => _BookingItemComponentState();
}

class _BookingItemComponentState extends State<BookingItemComponent> {
  bool loader = false;

  Future<void> coachAcceptOrRejectSessions(int status, int sessionId) async {
    setState(() {
      loader = true;
    });
    try {
      var request = <String, dynamic>{
        'status': status,
      };

      var response = await acceptOrRejectSessions(request, sessionId);
      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Saved Successfully.');
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? 'Something went wrong');
        }
      }
    } catch (e) {
      debugPrint('coachAcceptOrRejectSessions Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => buildBookingItem(context);

  Widget buildBookingItem(BuildContext context) {
    var sessionStatus =
        getSessionStatusFromCode(widget.serviceResource?.status ?? -1);

    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: nb.boxDecorationDefault(
          borderRadius: nb.radius(), color: context.cardColor),
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
                    imageUrl: getImageUrl(widget.serviceResource?.userDp),
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                    placeholder: (context, _) => Center(
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
                          '#${widget.serviceResource?.id}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.serviceResource?.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: nb.textSecondaryColor,
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
          buildDescriptionSection(
              context,
              widget.serviceResource?.date ?? '',
              widget.serviceResource?.startTime ?? '',
              widget.serviceResource?.remark ?? 'N/A',
              widget.serviceResource?.rating ?? ''),
          if (widget.showButtons)
            buildButtons(
                context,
                sessionStatus,
                widget.serviceResource?.id ?? -1,
                widget.serviceResource?.userId ?? -1)
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
    String description,
    String ratings,
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
                    formatDateTimeCustom(date, time),
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ).paddingAll(8),
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
            if (ratings.isNotEmpty)
              Column(
                children: [
                  const Divider(height: 0, color: Colors.black12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rating',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PannableRatingBar.builder(
                          rate: '$ratings'.toDouble(),
                          alignment: WrapAlignment.end,
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
                      ),
                    ],
                  ).paddingAll(8),
                ],
              ),
          ],
        ),
      );

  void showConfirmationDialog(
      BuildContext outerContext, int status, int sessionId) {
    showDialog(
      context: outerContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('You want to decline this session?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await coachAcceptOrRejectSessions(status, sessionId);
              widget.onActionPerformed();
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  Future<void> onCall(sessionId, coachId) async {
    var permissionsGranted =
        await PermissionUtils.requestNearbyDevicesPermissions(context);
    if (permissionsGranted) {
      var completed = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VideoCallPage(
                sessionId: sessionId,
              )));
      if (completed) {
        if (!appStore.userTypeCoach) {
          showRatingDialog(context, sessionId: sessionId, coachId: coachId, onActionPerformed: (){
            widget.onActionPerformed();
          });
        }
        widget.onActionPerformed();
      }
    } else {
      debugPrint(
          'Go to the Settings → Applications → Manage Applications → JumpCC → Enable Nearby Devices');
      SnackBarHelper.showStatusSnackBar(context, StatusIndicator.warning,
          'Go to Settings > Apps > $APP_NAME > Permissions and allow access to the Camera and Microphone.');
    }
  }

  Widget buildButtons(BuildContext context, SessionStatus status, int sessionId,
          int coachId) =>
      Row(
        children: [
          if (status == SessionStatus.pending)
            Row(
              children: [
                if (appStore.userTypeCoach)
                  AppButton(
                    text: 'Decline',
                    textColor: primaryColor,
                    color: nb.white,
                    enabled: true,
                    onTap: () {
                      showConfirmationDialog(
                          context,
                          getSessionStatusCode(SessionStatus.rejected),
                          sessionId);
                    },
                  ).expand(),
                if (appStore.userTypeCoach)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                AppButton(
                  text: appStore.userTypeCoach ? 'Accept' : 'Pending',
                  textColor: nb.white,
                  color: primaryColor,
                  enabled: true,
                  onTap: () async {
                    if (appStore.userTypeCoach) {
                      await coachAcceptOrRejectSessions(
                          getSessionStatusCode(SessionStatus.accepted),
                          sessionId);
                      widget.onActionPerformed();
                    }
                  },
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.accepted)
            Row(
              children: [
                AppButton(
                  text: 'Accepted',
                  textColor: nb.white,
                  color: getColorByStatus(status),
                  enabled: true,
                  onTap: () async {
                    await onCall(sessionId, coachId);
                  },
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.rejected)
            Row(
              children: [
                AppButton(
                  text: 'Rejected',
                  textColor: nb.white,
                  color: getColorByStatus(status),
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.abandoned)
            Row(
              children: [
                AppButton(
                  text: 'Abandoned',
                  textColor: Colors.black38,
                  color: getColorByStatus(status),
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.completed)
            Row(
              children: [
                AppButton(
                  text: 'Completed',
                  textColor: Colors.black38,
                  color: primaryColor,
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.expired)
            Row(
              children: [
                AppButton(
                  text: 'Expired',
                  textColor: nb.white,
                  color: getColorByStatus(status),
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.waiting)
            Row(
              children: [
                AppButton(
                  text: 'Join Call',
                  textColor: Colors.white,
                  color: getColorByStatus(SessionStatus.completed),
                  onTap: () async {
                    await onCall(sessionId, coachId);
                  },
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.waitingInProgress)
            Row(
              children: [
                AppButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.call,
                        color: nb.white,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      const Text(
                        'Join Call',
                        style: TextStyle(color: nb.white),
                      )
                    ],
                  ),
                  textColor: Colors.white,
                  color: getColorByStatus(SessionStatus.completed),
                  onTap: () async {
                    await onCall(sessionId, coachId);
                  },
                ).expand(),
              ],
            ).expand(),
        ],
      );
}

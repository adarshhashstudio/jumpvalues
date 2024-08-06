import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/requested_sessions_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/video_calling_module/video_call_page.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart' as nb;

class BookingItemComponent extends StatefulWidget {
  BookingItemComponent({
    required this.showButtons,
    this.serviceResource,
    this.index,
  });
  final bool showButtons;
  final RequestedSession? serviceResource;
  final int? index;

  @override
  State<BookingItemComponent> createState() => _BookingItemComponentState();
}

class _BookingItemComponentState extends State<BookingItemComponent> {
  bool loader = false;

  Future<void> coachAcceptOrRejectSessions(int status) async {
    setState(() {
      loader = true;
    });
    try {
      var request = <String, dynamic>{
        'status': status,
      };

      var response = await acceptOrRejectSessions(request);
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
    // Use data from bookingItem instead of dummy data
    var status = widget.serviceResource?.status ?? 0;
    SessionStatus sessionStatus;

    if (status == 0) {
      sessionStatus = SessionStatus.pending;
    } else if (status == 1) {
      sessionStatus = SessionStatus.accepted;
    } else if (status == 2) {
      sessionStatus = SessionStatus.rejected;
    } else if (status == 3) {
       sessionStatus = SessionStatus.waitingInProgress;
    } else if (status == 4) {
     sessionStatus = SessionStatus.completed;
    } else {
      sessionStatus = SessionStatus.expired;
    } 

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
              widget.serviceResource?.remark ?? 'N/A'),
          if (widget.showButtons) buildButtons(context, sessionStatus)
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

  Widget buildButtons(BuildContext context, SessionStatus status) => Row(
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
                    onTap: () {},
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
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.accepted)
            Row(
              children: [
                AppButton(
                  text: 'Accepted',
                  textColor: nb.white,
                  color: primaryColor,
                  enabled: true,
                  onTap: () {},
                ).expand(),
              ],
            ).expand(),
          if (status == SessionStatus.rejected)
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
          if (status == SessionStatus.waitingInProgress)
            Row(
              children: [
                AppButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.av_timer,
                        color: nb.white,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      const Text(
                        'In Progress',
                        style: TextStyle(color: nb.white),
                      )
                    ],
                  ),
                  textColor: nb.white,
                  color: primaryColor,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VideoCallPage()));
                  },
                ).expand(),
              ],
            ).expand(),
        ],
      );
}

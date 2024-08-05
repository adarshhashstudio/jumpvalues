import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/booking_item_model.dart';
import 'package:jumpvalues/models/service_resource.dart';
import 'package:jumpvalues/screens/video_calling_module/video_call_page.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart' as nb;

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
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var time = DateFormat.jms().format(DateTime.now());
    var customerName =
        serviceResource?.lastName ?? bookingItem.customerName ?? 'Customer';
    var description = serviceResource?.email ??
        bookingItem.description ??
        'No description available';
    

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
          if (status == 'accepted')
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

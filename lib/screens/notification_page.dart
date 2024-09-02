import 'package:flutter/material.dart';
import 'package:jumpvalues/models/notification_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  final List<NotificationData> notificationsList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool redirecting = false;

  @override
  void initState() {
    super.initState();
    getAllNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getAllNotifications();
      }
    });
  }

  Future<void> getAllNotifications() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await getNotifications(page: _currentPage);

      if (response?.status == true) {
        setState(() {
          notificationsList.addAll(response?.data ?? []);
          _currentPage++;
          _hasMoreData = (response?.pageDetails?.noOfRecords ?? 0) >
              (notificationsList.length);
        });
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('getNotifications error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> readThisNotification(int notificationId) async {
    setState(() {
      redirecting = false;
    });
    try {
      var response = await readNotification(notificationId);

      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Notification Read');
        Navigator.of(context).pop(true);
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('readNotification error: $e');
    } finally {
      setState(() {
        redirecting = false;
      });
    }
  }

  Future<void> _refreshBookingItems() async {
    setState(() {
      _currentPage = 1;
      notificationsList.clear();
      _hasMoreData = true;
    });
    await getAllNotifications();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Notifications',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.8),
                fontSize: 20),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (_isLoading && notificationsList.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                RefreshIndicator(
                  onRefresh: _refreshBookingItems,
                  child: (!_isLoading && notificationsList.isEmpty)
                      ? dataNotFoundWidget(context, onTap: _refreshBookingItems)
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: notificationsList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == notificationsList.length) {
                              return _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const SizedBox.shrink();
                            }
                            return ListTile(
                              onTap: () async {
                                await readThisNotification(
                                    notificationsList[index].id ?? -1);
                              },
                              selectedTileColor: greenColor.withOpacity(0.1),
                              selected: notificationsList[index].isRead == 0,
                              leading: redirecting
                                  ? Transform.scale(
                                      scale: 0.5,
                                      child: const CircularProgressIndicator())
                                  : const Icon(
                                      Icons.notifications_active_outlined,
                                      color: black,
                                    ),
                              title: Text(
                                notificationsList[index].title ?? '',
                                style: boldTextStyle(size: 15),
                              ),
                              dense: true,
                              subtitle: Text(
                                notificationsList[index].message ?? '',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${DateTimeUtils.formatToUSDateTime('${notificationsList[index].createdAt}')}',
                                    style: const TextStyle(color: black),
                                  ).paddingBottom(4),
                                ],
                              ),
                            );
                          }),
                ),
            ],
          ),
        ),
      );
}

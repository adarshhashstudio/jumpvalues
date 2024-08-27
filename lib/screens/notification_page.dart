import 'package:flutter/material.dart';
import 'package:jumpvalues/models/requested_sessions_response_model.dart';
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
  final List<RequestedSession> requestedSessions = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    clientRequestedSessions();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        clientRequestedSessions();
      }
    });
  }

  Future<void> clientRequestedSessions({
    String? searchData,
    int? status,
  }) async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await getCoachRequestedSessions(
        page: _currentPage,
        searchData: searchData,
        status: status,
      );

      if (response?.status == true) {
        setState(() {
          requestedSessions.addAll(response?.data ?? []);
          _currentPage++;
          _hasMoreData = (response?.pageDetails?.noOfRecords ?? 0) >
              (requestedSessions.length);
        });
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('availableCoaches error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshBookingItems() async {
    setState(() {
      _currentPage = 1;
      requestedSessions.clear();
      _hasMoreData = true;
    });
    await clientRequestedSessions();
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
              if (_isLoading && requestedSessions.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                RefreshIndicator(
                  onRefresh: _refreshBookingItems,
                  child: (!_isLoading && requestedSessions.isEmpty)
                      ? dataNotFoundWidget(context, onTap: _refreshBookingItems)
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: requestedSessions.length,
                          itemBuilder: (context, index) {
                            if (index == requestedSessions.length) {
                              return _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const SizedBox.shrink();
                            }
                            return ListTile(
                              selectedTileColor: greenColor.withOpacity(0.1),
                              selected: true,
                              title: Text(
                                'Notification Title',
                                style: boldTextStyle(size: 15),
                              ),
                              subtitle: const Text(
                                'notification subtitle',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                  '${formatDate(DateTime.now())} ${formatTimeCustom(DateTime.now())}'),
                            );
                          }),
                ),
            ],
          ),
        ),
      );
}

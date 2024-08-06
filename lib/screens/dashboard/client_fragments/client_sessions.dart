import 'package:flutter/material.dart';
import 'package:jumpvalues/models/requested_sessions_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/dashboard/booking_item_component.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ClientSessions extends StatefulWidget {
  const ClientSessions({super.key});

  @override
  State<ClientSessions> createState() => _ClientSessionsState();
}

class _ClientSessionsState extends State<ClientSessions> {
  SessionStatus selectedStatus = SessionStatus.all;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  final ScrollController _scrollController = ScrollController();
  final List<RequestedSession> requestedSessions = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      var response = await getClientRequestedSessions(
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
    await clientRequestedSessions(
        searchData: searchController.text,
        status: selectedStatus == SessionStatus.all
            ? null
            : getSessionStatusCode(selectedStatus));
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshBookingItems,
            child: (!_isLoading && requestedSessions.isEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        empty,
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      const Text(
                        'Data Not Available.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: primaryColor)
                              .onTap(_refreshBookingItems),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(
                            'Reload',
                            textAlign: TextAlign.center,
                            style: boldTextStyle(color: primaryColor),
                          ).onTap(_refreshBookingItems),
                        ],
                      ),
                    ],
                  ).center()
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: requestedSessions.length + 1,
                    separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                    itemBuilder: (context, index) {
                      if (index == requestedSessions.length) {
                        return _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      return BookingItemComponent(
                        showButtons: true,
                        serviceResource: requestedSessions[index],
                        index: index,
                        onActionPerformed: () async {
                          await _refreshBookingItems();
                        },
                      );
                    }).paddingOnly(left: 16, right: 16, bottom: 0, top: 70),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: isSearching
                          ? textFormField(
                              controller: searchController,
                              label: '',
                              isLabel: false,
                              hintText: 'Search',
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hideKeyboard(context);
                                    searchController.clear();
                                    isSearching = false;
                                    _refreshBookingItems();
                                  });
                                },
                                child: const Icon(Icons.clear),
                              ),
                              onChanged: (value) {
                                _debouncer.run(() {
                                  setState(() {
                                    isSearching = true;
                                    _refreshBookingItems();
                                  });
                                });
                              },
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: secondaryColor,
                                border: Border.all(
                                  color: secondaryColor,
                                ),
                              ),
                              child: DropdownButton<SessionStatus>(
                                value: selectedStatus,
                                items: SessionStatus.values
                                    .map((SessionStatus status) =>
                                        DropdownMenuItem<SessionStatus>(
                                          value: status,
                                          child: Text(getNameByStatus(status)),
                                        ))
                                    .toList(),
                                underline: const SizedBox(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                isExpanded: true,
                                onChanged: (SessionStatus? newValue) async {
                                  setState(() {
                                    selectedStatus = newValue!;
                                  });
                                  await _refreshBookingItems();
                                },
                              ),
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                      icon: Container(
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          width: 46,
                          height: 46,
                          child:
                              const Center(child: Icon(Icons.search_rounded))),
                    ),
                  ],
                ),
              )),
        ],
      );
}

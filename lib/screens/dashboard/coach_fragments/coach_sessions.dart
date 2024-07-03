import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/models/booking_item_model.dart';
import 'package:jumpvalues/models/service_resource.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachSessions extends StatefulWidget {
  const CoachSessions({super.key});

  @override
  State<CoachSessions> createState() => _CoachSessionsState();
}

class _CoachSessionsState extends State<CoachSessions> {
  String selectedStatus = 'All';
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  final ScrollController _scrollController = ScrollController();
  final List<ServiceResource> _bookingItems = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchSessionBookings();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchSessionBookings();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchSessionBookings() async {
    if (_isLoading || !_hasMoreData) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // futureBookingItems = fetchBookingItems();
      var dio = Dio();
      var response = await dio.get('https://reqres.in/api/users',
          queryParameters: {'page': _currentPage});
      debugPrint('${response.data}');
      var pagination = ServiceResourcePagination.fromJson(response.data);

      setState(() {
        _bookingItems.addAll(pagination.data ?? []);
        _currentPage++;
        _hasMoreData = _currentPage <= pagination.totalPages!;
      });
    } catch (e) {
      SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error, '$e');
      debugPrint('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<BookingItem> _filterBookingItems(List<BookingItem> bookingItems) {
    var filteredItems = bookingItems;

    if (selectedStatus != 'All') {
      filteredItems =
          filteredItems.where((item) => item.status == selectedStatus).toList();
    }

    if (isSearching && searchController.text.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) => item.serviceName!
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    return filteredItems;
  }

  Future<void> _refreshBookingItems() async {
    setState(() {
      _currentPage = 1;
      _bookingItems.clear();
      _hasMoreData = true;
    });
    fetchSessionBookings();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshBookingItems,
            child: (!_isLoading && _bookingItems.isEmpty)
                ? dataNotFoundWidget(context, onTap: _refreshBookingItems)
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: _bookingItems.length + 1,
                    separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                    itemBuilder: (context, index) {
                      if (index == _bookingItems.length) {
                        return _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      return BookingItemComponent(
                        showButtons: true,
                        bookingItem: BookingItem(),
                        serviceResource: _bookingItems[index],
                        index: index,
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
                                    searchController.clear();
                                    isSearching = false;
                                  });
                                },
                                child: const Icon(Icons.clear),
                              ),
                              onChanged: (value) {
                                setState(() {});
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
                              child: DropdownButton<String>(
                                value: selectedStatus,
                                items: [
                                  'All',
                                  'Pending',
                                  'In Progress',
                                  'Completed'
                                ]
                                    .map<DropdownMenuItem<String>>(
                                        (String value) =>
                                            DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            ))
                                    .toList(),
                                underline: const SizedBox(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue!;
                                  });
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

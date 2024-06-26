import 'package:flutter/material.dart';
import 'package:jumpvalues/models/booking_item_model.dart';
import 'package:jumpvalues/network/dummy.dart';
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
  late Future<List<BookingItem>> futureBookingItems;
  String selectedStatus = 'All';
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchSessionBookings();
  }

  void fetchSessionBookings() {
    try {
      futureBookingItems = fetchBookingItems();
    } catch (e) {
      SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error, '$e');
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
    fetchSessionBookings();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshBookingItems,
            child: SingleChildScrollView(
              child: FutureBuilder<List<BookingItem>>(
                future: futureBookingItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No bookings found.'));
                  } else {
                    var bookingItems = _filterBookingItems(snapshot.data!);
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: bookingItems.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      itemBuilder: (context, index) => BookingItemComponent(
                        showButtons: true,
                        bookingItem: bookingItems[index],
                      ),
                    ).paddingOnly(left: 16, right: 16, bottom: 50, top: 86);
                  }
                },
              ),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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

// class CoachSessions extends StatefulWidget {
//   const CoachSessions({super.key});

//   @override
//   State<CoachSessions> createState() => _CoachSessionsState();
// }

// class _CoachSessionsState extends State<CoachSessions> {
//   late ScrollController _scrollController;
//   List<BookingItem> _bookingItems = [];
//   bool _isLoading = false;
//   bool _hasMoreData = true;
//   int _currentPage = 1;

//   String selectedStatus = 'All';
//   TextEditingController searchController = TextEditingController();
//   bool isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController()..addListener(_scrollListener);
//     _fetchBookingItems();
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchBookingItems() async {
//     if (_isLoading) return;

//     setState(() {
//       _isLoading = true;
//     });

//     var newItems = await fetchBookingItemsWithPagination(_currentPage);
//     setState(() {
//       _bookingItems.addAll(newItems);
//       _isLoading = false;
//       _currentPage++;
//       if (newItems.length < 10) {
//         _hasMoreData = false;
//       }
//     });
//   }

//   Future<void> _refreshBookingItems() async {
//     setState(() {
//       _currentPage = 1;
//       _bookingItems.clear();
//       _hasMoreData = true;
//     });
//     await _fetchBookingItems();
//   }

//   List<BookingItem> _filterBookingItems(List<BookingItem> bookingItems) {
//     var filteredItems = bookingItems;

//     if (selectedStatus != 'All') {
//       filteredItems =
//           filteredItems.where((item) => item.status == selectedStatus).toList();
//     }

//     if (isSearching && searchController.text.isNotEmpty) {
//       filteredItems = filteredItems
//           .where((item) => item.serviceName!
//               .toLowerCase()
//               .contains(searchController.text.toLowerCase()))
//           .toList();
//     }

//     return filteredItems;
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       if (_hasMoreData) {
//         _fetchBookingItems();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Stack(
//         children: [
//           RefreshIndicator(
//             onRefresh: _refreshBookingItems,
//             child: ListView.builder(
//               controller: _scrollController,
//               physics: const AlwaysScrollableScrollPhysics(),
//               itemCount: _bookingItems.length + (_hasMoreData ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == _bookingItems.length) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }
//                 var bookingItem = _filterBookingItems(_bookingItems)[index];
//                 return BookingItemComponent(
//                   showButtons: true,
//                   bookingItem: bookingItem,
//                 ).paddingOnly(
//                   left: 16,
//                   right: 16,
//                   bottom: index == _bookingItems.length - 1 ? 50 : 0,
//                   top: index == 0 ? 86 : 0,
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: isSearching
//                         ? textFormField(
//                             controller: searchController,
//                             label: '',
//                             isLabel: false,
//                             hintText: 'Search',
//                             suffix: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   searchController.clear();
//                                   isSearching = false;
//                                 });
//                               },
//                               child: const Icon(Icons.clear),
//                             ),
//                             onChanged: (value) {
//                               setState(() {});
//                             },
//                           )
//                         : Container(
//                             width: MediaQuery.of(context).size.width * 1,
//                             height: MediaQuery.of(context).size.height * 0.06,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: secondaryColor,
//                               border: Border.all(
//                                 color: secondaryColor,
//                               ),
//                             ),
//                             child: DropdownButton<String>(
//                               value: selectedStatus,
//                               items: [
//                                 'All',
//                                 'Pending',
//                                 'In Progress',
//                                 'Completed'
//                               ]
//                                   .map<DropdownMenuItem<String>>(
//                                       (String value) =>
//                                           DropdownMenuItem<String>(
//                                             value: value,
//                                             child: Text(value),
//                                           ))
//                                   .toList(),
//                               underline: const SizedBox(),
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               isExpanded: true,
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   selectedStatus = newValue!;
//                                 });
//                               },
//                             ),
//                           ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       setState(() {
//                         isSearching = true;
//                       });
//                     },
//                     icon: Container(
//                         decoration: BoxDecoration(
//                             color: secondaryColor,
//                             borderRadius: BorderRadius.circular(8)),
//                         width: 46,
//                         height: 46,
//                         child: const Center(child: Icon(Icons.search_rounded))),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
// }

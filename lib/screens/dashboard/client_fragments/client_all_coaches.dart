import 'package:flutter/material.dart';
import 'package:jumpvalues/models/available_coaches_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/client_screens/coach_details_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ClientAllCoaches extends StatefulWidget {
  const ClientAllCoaches({super.key});

  @override
  State<ClientAllCoaches> createState() => _ClientAllCoachesState();
}

class _ClientAllCoachesState extends State<ClientAllCoaches> {
  TextEditingController searchController = TextEditingController();
  bool isSearched = false;
  final ScrollController _scrollController = ScrollController();
  List<AvailableCoaches> availableCoachList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    availableCoaches();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        availableCoaches();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshCoachItems() async {
    setState(() {
      _currentPage = 1;
      availableCoachList.clear();
      _hasMoreData = true;
    });
    await availableCoaches(searchData: searchController.text);
  }

  Future<void> availableCoaches({
    String? searchData,
    int? status,
  }) async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await getAvailableCoaches(
        page: _currentPage,
        searchData: searchData,
        status: status,
      );

      if (response?.status == true) {
        setState(() {
          availableCoachList.addAll(response?.data ?? []);
          _currentPage++;
          _hasMoreData = (response?.pageDetails?.noOfRecords ?? 0) >
              (availableCoachList.length);
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

  @override
  Widget build(BuildContext context) =>
      // Scaffold(
      // appBar: appStore.additionalSponsor.isEmpty
      //     ? null
      //     : AppBar(
      //         bottom: PreferredSize(
      //           preferredSize: const Size.fromHeight(4.0),
      //           child: Container(
      //             color: Colors.grey,
      //             height: 0.5,
      //           ),
      //         ),
      //         leading: GestureDetector(
      //           onTap: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: const Padding(
      //             padding: EdgeInsets.only(left: 14.0),
      //             child: Icon(Icons.arrow_back_ios_new),
      //           ),
      //         ),
      //         centerTitle: true,
      //         title: Text(
      //           'Available Coaches',
      //           style: TextStyle(
      //               fontWeight: FontWeight.w600,
      //               color: textColor.withOpacity(0.8),
      //               fontSize: 20),
      //         ),
      //       ),
      // body:
      Stack(
        children: [
          if (_isLoading && availableCoachList.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            RefreshIndicator(
              onRefresh: _refreshCoachItems,
              child: (!_isLoading && availableCoachList.isEmpty)
                  ? dataNotFoundWidget(context, onTap: _refreshCoachItems)
                  : ListView.separated(
                      controller: _scrollController,
                      itemCount: availableCoachList.length + 1,
                      separatorBuilder: (context, index) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                      itemBuilder: (context, index) {
                        // If the current index is the last one (the additional one), show the loader
                        if (index == availableCoachList.length) {
                          // Check if there is more data to load; if not, return an empty SizedBox
                          return _hasMoreData
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                        // Otherwise, return the usual BookingItemComponent
                        return CoachItemComponent(
                          coachDetail: availableCoachList[index],
                          index: index,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CoachDetailsScreen(
                                    coachDetail: availableCoachList[index]),
                              ),
                            );
                          },
                        );
                      }).paddingOnly(left: 16, right: 16, bottom: 0, top: 70),
            ),
          Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  children: [
                    Expanded(
                        child: textFormField(
                      controller: searchController,
                      label: '',
                      isLabel: false,
                      hintText: 'Search Coach',
                      suffix: isSearched
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  hideKeyboard(context);
                                  searchController.clear();
                                  isSearched = false;
                                  _refreshCoachItems();
                                });
                              },
                              child: const Icon(Icons.clear),
                            )
                          : null,
                      borderRadius: 8,
                      onChanged: (value) {
                        _debouncer.run(() {
                          setState(() {
                            isSearched = true;
                            _refreshCoachItems();
                          });
                        });
                      },
                    )),
                  ],
                ),
              )),
        ],
      );
  // );
}

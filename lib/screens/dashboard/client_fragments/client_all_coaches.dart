import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/models/service_resource.dart';
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
  final List<ServiceResource> _coachList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    fetchAllCoaches();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchAllCoaches();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void fetchAllCoaches({String? query}) async {
    if (_isLoading || !_hasMoreData) return;
    setState(() {
      _isLoading = true;
    });
    try {
      var dio = Dio();
      var response =
          await dio.get('https://reqres.in/api/users', queryParameters: {
        'page': _currentPage,
        if (query != null) 'search': query,
      });

      debugPrint('${response.data}');
      var pagination = ServiceResourcePagination.fromJson(response.data);

      setState(() {
        _coachList.addAll(pagination.data ?? []);
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

  List<ServiceResource> _filterCoachItems() {
    var filteredItems = _coachList;
    if (searchController.text.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) => item.firstName!
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    return filteredItems;
  }

  Future<void> _refreshCoachItems() async {
    setState(() {
      _currentPage = 1;
      _coachList.clear();
      _hasMoreData = true;
    });
    fetchAllCoaches();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshCoachItems,
            child: (!_isLoading && _coachList.isEmpty)
                ? dataNotFoundWidget(context, onTap: _refreshCoachItems)
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: _filterCoachItems().length + 1,
                    separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                    itemBuilder: (context, index) {
                      if (index == _filterCoachItems().length) {
                        return _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      return CoachItemComponent(
                        coachDetail: _filterCoachItems()[index],
                        index: index,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CoachDetailsScreen(
                                  coachDetail: _filterCoachItems()[index]),
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
}

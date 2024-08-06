import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/models/service_resource.dart';
import 'package:jumpvalues/screens/dashboard/booking_item_component.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  final List<ServiceResource> _bookingItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    isTokenAvailable(context);
    super.initState();
    fetchSessionBookings();
  }

  void fetchSessionBookings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // futureBookingItems = fetchBookingItems();
      var dio = Dio();
      var response = await dio
          .get('https://reqres.in/api/users', queryParameters: {'page': 1});
      debugPrint('${response.data}');
      ServiceResourcePagination pagination =
          ServiceResourcePagination.fromJson(response.data);

      setState(() {
        _bookingItems.addAll(pagination.data ?? []);
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

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                todaySession(context, total: '5'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TotalWidget(
                        icon: icUpcoming,
                        title: 'Upcoming Sessions',
                        total: '10',
                        color: white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Expanded(
                      child: TotalWidget(
                        icon: icCompleted,
                        title: 'Completed Sessions',
                        total: '8',
                        color: white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  children: [
                    Text('Recent Requests ', style: boldTextStyle()),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2,
                        separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        itemBuilder: (context, index) => BookingItemComponent(
                          showButtons: false,
                          // serviceResource: _bookingItems[index],
                          index: index,
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
}

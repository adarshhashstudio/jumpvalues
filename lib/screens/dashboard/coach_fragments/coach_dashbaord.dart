import 'package:flutter/material.dart';
import 'package:jumpvalues/models/booking_item_model.dart';
import 'package:jumpvalues/network/dummy.dart';
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
  late Future<List<BookingItem>> futureBookingItems;

  @override
  void initState() {
    isTokenAvailable(context);
    super.initState();
    futureBookingItems = fetchBookingItems();
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
                FutureBuilder<List<BookingItem>>(
                  future: futureBookingItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No bookings found.'));
                    } else {
                      var bookingItems = snapshot.data!;
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 1,
                        separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        itemBuilder: (context, index) => BookingItemComponent(
                          showButtons: false,
                          bookingItem: bookingItems[index],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
}

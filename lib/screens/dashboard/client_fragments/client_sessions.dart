import 'package:flutter/material.dart';
import 'package:jumpvalues/models/booking_item_model.dart';
import 'package:jumpvalues/network/dummy.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ClientSessions extends StatefulWidget {
  const ClientSessions({super.key});

  @override
  State<ClientSessions> createState() => _ClientSessionsState();
}

class _ClientSessionsState extends State<ClientSessions> {
  late Future<List<BookingItem>> futureBookingItems;

  @override
  void initState() {
    super.initState();
    futureBookingItems = fetchBookingItems();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
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
              var bookingItems = snapshot.data!;
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
              ).paddingSymmetric(horizontal: 16, vertical: 16);
            }
          },
        ),
      );
}

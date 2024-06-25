import 'dart:convert';

import 'package:jumpvalues/models/booking_item_model.dart';

Future<List<BookingItem>> fetchBookingItems() async {
  await Future.delayed(
      const Duration(milliseconds: 600)); // Simulate network delay

  var jsonString = '''
  [
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/27/200/300",
      "bookingId": "456",
      "serviceName": "Motivation Meeting",
      "date": "2023-12-31",
      "time": "12:00 PM",
      "customerName": "John Dey",
      "description": "I want to take some motivations."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/29/200/300",
      "bookingId": "123",
      "serviceName": "Diet Consultation",
      "date": "2024-02-01",
      "time": "02:00 PM",
      "customerName": "Michael Smith",
      "description": "Discussing diet plans."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/28/200/300",
      "bookingId": "789",
      "serviceName": "Fitness Session",
      "date": "2024-01-05",
      "time": "10:00 AM",
      "customerName": "Jane Doe",
      "description": "I need a fitness plan."
    }
  ]
  ''';

  List<dynamic> jsonList = json.decode(jsonString);
  var bookingItems =
      jsonList.map((json) => BookingItem.fromJson(json)).toList();
  return bookingItems;
}

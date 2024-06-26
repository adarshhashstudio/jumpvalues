import 'dart:convert';

import 'package:jumpvalues/models/booking_item_model.dart';
import 'package:jumpvalues/widgets/slots_calendar.dart';

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

Future<List<Meeting>> fetchMeetings() async {
  await Future.delayed(const Duration(seconds: 1));

  var jsonString = '''[
      {
        "eventName": "Available Session",
        "from": "2024-06-26T13:00:00",
        "to": "2024-06-26T14:00:00",
        "background": "0xFF0F8644",
        "description": "Description for Availble Session",
        "isAllDay": false
      },
      {
        "eventName": "Motivation Session",
        "from": "2024-06-27T09:00:00",
        "to": "2024-06-27T10:00:00",
        "background": "0xFF0F8644",
        "description": "Description for Motivation Session",
        "isAllDay": false
      },
      {
        "eventName": "Diet Plan",
        "from": "2024-06-27T11:00:00",
        "to": "2024-06-27T12:00:00",
        "background": "0xFF0F8644",
        "description": "Description for Diet Plan",
        "isAllDay": false
      },
      {
        "eventName": "Fitness Training",
        "from": "2024-06-28T14:00:00",
        "to": "2024-06-28T15:00:00",
        "background": "0xFF0F8644",
        "description": "Description for Fitness Training",
        "isAllDay": false
      }
    ]''';

  List<dynamic> jsonList = json.decode(jsonString);
  var meetings = jsonList.map((json) => Meeting.fromJson(json)).toList();
  return meetings;
}

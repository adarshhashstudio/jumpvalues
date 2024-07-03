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

Future<List<BookingItem>> fetchBookingItemsWithPagination(int page) async {
  await Future.delayed(
      const Duration(milliseconds: 600)); // Simulate network delay

  var jsonString = '''
  {
  "data": [
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/1/200/300",
      "bookingId": "1",
      "serviceName": "Motivation Meeting",
      "date": "2023-12-31",
      "time": "12:00 PM",
      "customerName": "John Dey",
      "description": "I want to take some motivations."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/2/200/300",
      "bookingId": "2",
      "serviceName": "Diet Consultation",
      "date": "2024-02-01",
      "time": "02:00 PM",
      "customerName": "Michael Smith",
      "description": "Discussing diet plans."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/3/200/300",
      "bookingId": "3",
      "serviceName": "Fitness Session",
      "date": "2024-01-05",
      "time": "10:00 AM",
      "customerName": "Jane Doe",
      "description": "I need a fitness plan."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/4/200/300",
      "bookingId": "4",
      "serviceName": "Yoga Class",
      "date": "2024-03-12",
      "time": "09:00 AM",
      "customerName": "Alice Johnson",
      "description": "Yoga for beginners."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/5/200/300",
      "bookingId": "5",
      "serviceName": "Wellness Consultation",
      "date": "2024-04-15",
      "time": "11:00 AM",
      "customerName": "Bob Brown",
      "description": "Discussing wellness strategies."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/6/200/300",
      "bookingId": "6",
      "serviceName": "Therapy Session",
      "date": "2024-05-20",
      "time": "03:00 PM",
      "customerName": "Carol White",
      "description": "Therapy for stress relief."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/7/200/300",
      "bookingId": "7",
      "serviceName": "Life Coaching",
      "date": "2024-06-22",
      "time": "04:00 PM",
      "customerName": "David Green",
      "description": "Life coaching session."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/8/200/300",
      "bookingId": "8",
      "serviceName": "Career Counseling",
      "date": "2024-07-30",
      "time": "01:00 PM",
      "customerName": "Eve Black",
      "description": "Discussing career options."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/9/200/300",
      "bookingId": "9",
      "serviceName": "Health Checkup",
      "date": "2024-08-15",
      "time": "10:00 AM",
      "customerName": "Frank Brown",
      "description": "General health checkup."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/10/200/300",
      "bookingId": "10",
      "serviceName": "Nutrition Advice",
      "date": "2024-09-20",
      "time": "02:00 PM",
      "customerName": "Grace Smith",
      "description": "Advice on nutrition."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/11/200/300",
      "bookingId": "11",
      "serviceName": "Mental Health Session",
      "date": "2024-10-05",
      "time": "03:00 PM",
      "customerName": "Henry Johnson",
      "description": "Session for mental health."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/12/200/300",
      "bookingId": "12",
      "serviceName": "Fitness Training",
      "date": "2024-11-10",
      "time": "11:00 AM",
      "customerName": "Isabella Lee",
      "description": "Personal fitness training."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/13/200/300",
      "bookingId": "13",
      "serviceName": "Meditation Class",
      "date": "2024-12-01",
      "time": "05:00 PM",
      "customerName": "Jack White",
      "description": "Introduction to meditation."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/14/200/300",
      "bookingId": "14",
      "serviceName": "Stress Management",
      "date": "2024-12-15",
      "time": "09:00 AM",
      "customerName": "Kelly Brown",
      "description": "Managing stress effectively."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/15/200/300",
      "bookingId": "15",
      "serviceName": "Group Therapy",
      "date": "2024-01-20",
      "time": "10:00 AM",
      "customerName": "Liam Green",
      "description": "Group therapy session."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/16/200/300",
      "bookingId": "16",
      "serviceName": "Weight Loss Program",
      "date": "2024-02-25",
      "time": "01:00 PM",
      "customerName": "Mason Clark",
      "description": "Weight loss consultation."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/17/200/300",
      "bookingId": "17",
      "serviceName": "Physical Therapy",
      "date": "2024-03-10",
      "time": "11:00 AM",
      "customerName": "Nora Walker",
      "description": "Physical therapy session."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/18/200/300",
      "bookingId": "18",
      "serviceName": "Chiropractic Adjustment",
      "date": "2024-04-05",
      "time": "02:00 PM",
      "customerName": "Olivia Hill",
      "description": "Chiropractic adjustment."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/19/200/300",
      "bookingId": "19",
      "serviceName": "Acupuncture Session",
      "date": "2024-05-15",
      "time": "04:00 PM",
      "customerName": "Paul Martinez",
      "description": "Acupuncture for pain relief."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/20/200/300",
      "bookingId": "20",
      "serviceName": "Massage Therapy",
      "date": "2024-06-20",
      "time": "01:00 PM",
      "customerName": "Quinn Lee",
      "description": "Therapeutic massage session."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/21/200/300",
      "bookingId": "21",
      "serviceName": "Fitness Bootcamp",
      "date": "2024-07-25",
      "time": "06:00 AM",
      "customerName": "Riley Clark",
      "description": "Intensive fitness bootcamp."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/22/200/300",
      "bookingId": "22",
      "serviceName": "Diet Planning",
      "date": "2024-08-30",
      "time": "05:00 PM",
      "customerName": "Samantha Scott",
      "description": "Planning a balanced diet."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/23/200/300",
      "bookingId": "23",
      "serviceName": "Fitness Assessment",
      "date": "2024-09-15",
      "time": "08:00 AM",
      "customerName": "Tyler Young",
      "description": "Assessing fitness level."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/24/200/300",
      "bookingId": "24",
      "serviceName": "Health Consultation",
      "date": "2024-10-10",
      "time": "09:00 AM",
      "customerName": "Uma Patel",
      "description": "General health consultation."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/25/200/300",
      "bookingId": "25",
      "serviceName": "Nutritional Counseling",
      "date": "2024-11-20",
      "time": "03:00 PM",
      "customerName": "Victor Lopez",
      "description": "Counseling for better nutrition."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/26/200/300",
      "bookingId": "26",
      "serviceName": "Life Balance Coaching",
      "date": "2024-12-05",
      "time": "02:00 PM",
      "customerName": "Wendy Lee",
      "description": "Coaching for life balance."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/27/200/300",
      "bookingId": "27",
      "serviceName": "Motivation Meeting",
      "date": "2024-01-15",
      "time": "12:00 PM",
      "customerName": "Xander Brown",
      "description": "Motivational session."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/28/200/300",
      "bookingId": "28",
      "serviceName": "Fitness Session",
      "date": "2024-02-10",
      "time": "10:00 AM",
      "customerName": "Yara Davis",
      "description": "Creating a fitness plan."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/29/200/300",
      "bookingId": "29",
      "serviceName": "Diet Consultation",
      "date": "2024-03-05",
      "time": "02:00 PM",
      "customerName": "Zane Carter",
      "description": "Diet consultation."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/30/200/300",
      "bookingId": "30",
      "serviceName": "Yoga Session",
      "date": "2024-04-10",
      "time": "09:00 AM",
      "customerName": "Amy Brown",
      "description": "Advanced yoga session."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/31/200/300",
      "bookingId": "31",
      "serviceName": "Wellness Coaching",
      "date": "2024-05-15",
      "time": "11:00 AM",
      "customerName": "Brian Johnson",
      "description": "Wellness coaching."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/32/200/300",
      "bookingId": "32",
      "serviceName": "Therapy Session",
      "date": "2024-06-20",
      "time": "03:00 PM",
      "customerName": "Clara Lee",
      "description": "Therapy for anxiety."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/33/200/300",
      "bookingId": "33",
      "serviceName": "Health Assessment",
      "date": "2024-07-25",
      "time": "10:00 AM",
      "customerName": "Daniel Clark",
      "description": "Comprehensive health assessment."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/34/200/300",
      "bookingId": "34",
      "serviceName": "Mental Health Consultation",
      "date": "2024-08-30",
      "time": "04:00 PM",
      "customerName": "Emma Walker",
      "description": "Consultation for mental health."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/35/200/300",
      "bookingId": "35",
      "serviceName": "Fitness Bootcamp",
      "date": "2024-09-15",
      "time": "08:00 AM",
      "customerName": "Fiona Martinez",
      "description": "Intensive bootcamp training."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/36/200/300",
      "bookingId": "36",
      "serviceName": "Nutrition Coaching",
      "date": "2024-10-10",
      "time": "09:00 AM",
      "customerName": "George Lopez",
      "description": "Coaching for nutrition."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/37/200/300",
      "bookingId": "37",
      "serviceName": "Life Coaching",
      "date": "2024-11-20",
      "time": "03:00 PM",
      "customerName": "Hannah Lee",
      "description": "Life coaching session."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/38/200/300",
      "bookingId": "38",
      "serviceName": "Fitness Training",
      "date": "2024-12-05",
      "time": "02:00 PM",
      "customerName": "Ian Clark",
      "description": "Personal fitness training."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/39/200/300",
      "bookingId": "39",
      "serviceName": "Therapy Session",
      "date": "2024-01-15",
      "time": "12:00 PM",
      "customerName": "Jackie Green",
      "description": "Therapy session."
    },
    {
      "status": "Pending",
      "imageUrl": "https://picsum.photos/id/40/200/300",
      "bookingId": "40",
      "serviceName": "Yoga Class",
      "date": "2024-02-10",
      "time": "10:00 AM",
      "customerName": "Karen Davis",
      "description": "Yoga class for relaxation."
    },
    {
      "status": "In Progress",
      "imageUrl": "https://picsum.photos/id/41/200/300",
      "bookingId": "41",
      "serviceName": "Diet Consultation",
      "date": "2024-03-05",
      "time": "02:00 PM",
      "customerName": "Liam Carter",
      "description": "Discussing diet plans."
    },
    {
      "status": "Completed",
      "imageUrl": "https://picsum.photos/id/42/200/300",
      "bookingId": "42",
      "serviceName": "Fitness Session",
      "date": "2024-04-10",
      "time": "09:00 AM",
      "customerName": "Mia Johnson",
      "description": "Creating a fitness plan."
    }
  ],
  "pagination": {
    "totalItems": 42,
    "totalPage": 5,
    "currentPage": 1,
    "nextPage": 2,
    "previousPage": 0,
    "limit": 10
  }
}
  ''';

  var jsonResponse = json.decode(jsonString) as Map<String, dynamic>;
  var bookingItems = (jsonResponse['data'] as List)
      .map((json) => BookingItem.fromJson(json))
      .toList();
  return bookingItems;
}

Future<List<Meeting>> fetchMeetings() async {
  await Future.delayed(const Duration(seconds: 1));

  var jsonString = '''[
  {
    "eventName": "Evening Yoga Session",
    "from": "2024-07-03T17:30:00",
    "to": "2024-07-03T18:30:00",
    "background": "0xFF0F8644",
    "description": "Description for Evening Yoga Session",
    "isAllDay": false
  },
  {
    "eventName": "Night Meditation",
    "from": "2024-07-03T19:00:00",
    "to": "2024-07-03T20:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Night Meditation",
    "isAllDay": false
  },
  {
    "eventName": "Morning Run",
    "from": "2024-07-04T06:00:00",
    "to": "2024-07-04T07:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Morning Run",
    "isAllDay": false
  },
  {
    "eventName": "Healthy Breakfast Talk",
    "from": "2024-07-04T08:00:00",
    "to": "2024-07-04T09:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Healthy Breakfast Talk",
    "isAllDay": false
  },
  {
    "eventName": "Strength Training",
    "from": "2024-07-04T10:00:00",
    "to": "2024-07-04T11:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Strength Training",
    "isAllDay": false
  },
  {
    "eventName": "Lunch & Learn",
    "from": "2024-07-04T12:00:00",
    "to": "2024-07-04T13:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Lunch & Learn",
    "isAllDay": false
  },
  {
    "eventName": "Afternoon Pilates",
    "from": "2024-07-04T15:00:00",
    "to": "2024-07-04T16:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Afternoon Pilates",
    "isAllDay": false
  },
  {
    "eventName": "Evening Yoga",
    "from": "2024-07-04T18:00:00",
    "to": "2024-07-04T19:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Evening Yoga",
    "isAllDay": false
  },
  {
    "eventName": "Morning Swim",
    "from": "2024-07-05T07:00:00",
    "to": "2024-07-05T08:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Morning Swim",
    "isAllDay": false
  },
  {
    "eventName": "Cardio Blast",
    "from": "2024-07-05T09:00:00",
    "to": "2024-07-05T10:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Cardio Blast",
    "isAllDay": false
  },
  {
    "eventName": "Mindfulness Session",
    "from": "2024-07-05T11:00:00",
    "to": "2024-07-05T12:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Mindfulness Session",
    "isAllDay": false
  },
  {
    "eventName": "Nutrition Workshop",
    "from": "2024-07-05T13:00:00",
    "to": "2024-07-05T14:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Nutrition Workshop",
    "isAllDay": false
  },
  {
    "eventName": "Fitness Bootcamp",
    "from": "2024-07-05T16:00:00",
    "to": "2024-07-05T17:00:00",
    "background": "0xFF0F8644",
    "description": "Description for Fitness Bootcamp",
    "isAllDay": false
  }
]
''';

  List<dynamic> jsonList = json.decode(jsonString);
  var meetings = jsonList.map((json) => Meeting.fromJson(json)).toList();
  return meetings;
}

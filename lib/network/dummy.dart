import 'dart:convert';
import 'package:jumpvalues/widgets/slots_calendar.dart';

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

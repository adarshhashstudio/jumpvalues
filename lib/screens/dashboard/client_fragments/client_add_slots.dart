import 'package:flutter/material.dart';
import 'package:jumpvalues/widgets/slots_calendar.dart';

class ClientAddSlots extends StatefulWidget {
  const ClientAddSlots({super.key});

  @override
  State<ClientAddSlots> createState() => _ClientAddSlotsState();
}

class _ClientAddSlotsState extends State<ClientAddSlots> {
  List<Meeting> globalMeetings = [
    Meeting(
      'Motivation Session',
      DateTime(2024, 6, 25, 9, 0),
      DateTime(2024, 6, 25, 10, 0),
      const Color(0xFF0F8644),
      false,
    ),
    Meeting(
      'Diat Plan',
      DateTime(2024, 6, 25, 11, 0),
      DateTime(2024, 6, 25, 12, 0),
      const Color(0xFF0F8644),
      false,
    )
  ];

  // Method to add or remove a meeting based on selected slot
  void handleSlotSelection(DateTime selectedDate, DateTime startTime,
      DateTime endTime, String title) {
    setState(() {
      // Remove any existing meeting that matches the selected slot
      globalMeetings.removeWhere((meeting) =>
          meeting.from == startTime &&
          meeting.to == endTime &&
          meeting.eventName == title);

      // Add the selected slot as a new meeting
      globalMeetings.add(
          Meeting(title, startTime, endTime, const Color(0xFF0F8644), false));

      // Optionally, you can sort the meetings by startTime if needed
      globalMeetings.sort((a, b) => a.from.compareTo(b.from));
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        child: Center(
          child: SlotsCalendar(
            meetings: globalMeetings,
            onSlotSelected: (DateTime selectedDate, DateTime startTime,
                DateTime endTime, String title, List<Meeting> allSlots) {
              handleSlotSelection(selectedDate, startTime, endTime, title);
            },
          ),
        ),
      );
}

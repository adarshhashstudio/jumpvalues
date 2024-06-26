import 'package:flutter/material.dart';
import 'package:jumpvalues/widgets/slots_calendar.dart';

class CoachAddSlots extends StatefulWidget {
  const CoachAddSlots({super.key});

  @override
  State<CoachAddSlots> createState() => _CoachAddSlotsState();
}

class _CoachAddSlotsState extends State<CoachAddSlots> {
  List<Meeting> globalMeetings = [];

  // Method to add or remove a meeting based on selected slot
  void handleSlotSelection(DateTime selectedDate, DateTime startTime,
      DateTime endTime, String title, String description) {
    setState(() {
      // // Remove any existing meeting that matches the selected slot
      // globalMeetings.removeWhere((meeting) =>
      //     meeting.from == startTime &&
      //     meeting.to == endTime &&
      //     meeting.eventName == title);

      // // Add the selected slot as a new meeting
      // globalMeetings.add(Meeting(title, startTime, endTime,
      //     const Color(0xFF0F8644), 'description', false));

      // // Optionally, you can sort the meetings by startTime if needed
      // globalMeetings.sort((a, b) => a.from.compareTo(b.from));
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        child: Center(
          child: SlotsCalendar(
            meetings: globalMeetings,
            onSlotSelected: (
              DateTime selectedDate,
              DateTime startTime,
              DateTime endTime,
              String title,
              String description,
              List<Meeting> allSlots,
            ) {
              handleSlotSelection(
                  selectedDate, startTime, endTime, title, description);
            },
          ),
        ),
      );
}

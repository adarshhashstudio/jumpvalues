import 'package:flutter/material.dart';
import 'package:jumpvalues/network/dummy.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/slots_calendar.dart';

class ClientAddSlots extends StatefulWidget {
  const ClientAddSlots({super.key});

  @override
  State<ClientAddSlots> createState() => _ClientAddSlotsState();
}

class _ClientAddSlotsState extends State<ClientAddSlots> {
  bool loader = true;
  List<Meeting> globalMeetings = [];

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  void fetchSlots() async {
    try {
      await fetchMeetings().then((meetings) {
        setState(() {
          globalMeetings = meetings;
          loader = false;
        });
      });
    } catch (e) {
      setState(() {
        globalMeetings = [];
        loader = false;
      });
      SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error, '$e');
    }
  }

  // Method to update a meeting based on selected slot
  void updateMeeting(
      DateTime startTime, DateTime endTime, String title, String description) {
    setState(() {
      // Find the meeting to be updated
      var index = globalMeetings.indexWhere((meeting) {
        debugPrint('${meeting.eventName} == $title');
        debugPrint('${meeting.from} == $startTime');
        debugPrint('${meeting.to} == $endTime');
        debugPrint('${meeting.description} == $description');
        return meeting.from == startTime &&
            meeting.to == endTime &&
            meeting.eventName == title;
      });

      if (index != -1) {
        // Update the meeting details
        globalMeetings[index] = Meeting('Booked - $title', startTime, endTime,
            const Color(0xFF55560C), description, false);

        // Optionally, you can sort the meetings by startTime if needed
        globalMeetings.sort((a, b) => a.from.compareTo(b.from));

        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.success, 'Slot Booked Successfully.');
      }
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SizedBox(
            child: Center(
              child: SlotsCalendar(
                meetings: globalMeetings,
                startBooking: true,
                onSlotSelected: (
                  DateTime selectedDate,
                  DateTime startTime,
                  DateTime endTime,
                  String title,
                  String description,
                  List<Meeting> allSlots,
                ) {},
                onSlotBooking: (DateTime selectedDate, DateTime startTime,
                    DateTime endTime, String title, String description) {
                  if (!loader) {
                    if (!loader) {
                      if (title.contains('Booked')) {
                        SnackBarHelper.showStatusSnackBar(context,
                            StatusIndicator.warning, 'Already Booked.');
                      } else {
                        updateMeeting(startTime, endTime, title, description);
                      }
                    }
                  }
                },
              ),
            ),
          ),
          if (loader)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      );
}

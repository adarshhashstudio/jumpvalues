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
  void updateMeeting(DateTime startTime, DateTime endTime, String title) {
    setState(() {
      // Find the meeting to be updated
      var index = globalMeetings.indexWhere((meeting) {
        debugPrint('${meeting.remark} == $title');
        debugPrint('${meeting.from} == $startTime');
        debugPrint('${meeting.to} == $endTime');
        return meeting.from == startTime &&
            meeting.to == endTime &&
            meeting.remark == title;
      });

      if (index != -1) {
        // Update the meeting details
        globalMeetings[index] = Meeting(
            'Booked - $title', startTime, endTime, const Color(0xFF55560C));

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
                  String selectSlotRemark,
                  List<Meeting> allSlots,
                ) {},
                onSlotBooking: (DateTime selectedDate, DateTime startTime,
                    DateTime endTime, String bookSlotRemark) {
                  if (!loader) {
                    if (!loader) {
                      if (bookSlotRemark.contains('Booked')) {
                        SnackBarHelper.showStatusSnackBar(context,
                            StatusIndicator.warning, 'Already Booked.');
                      } else {
                        updateMeeting(startTime, endTime, bookSlotRemark);
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

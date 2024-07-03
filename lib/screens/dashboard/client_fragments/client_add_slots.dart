import 'package:flutter/material.dart';
import 'package:jumpvalues/network/dummy.dart';
import 'package:jumpvalues/screens/dashboard/dashboard.dart';
import 'package:jumpvalues/utils/configs.dart';
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
  List<Meeting> selectedMeetings = [];

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

        selectedMeetings.add(globalMeetings[index]);

        // Optionally, you can sort the meetings by startTime if needed
        globalMeetings.sort((a, b) => a.from.compareTo(b.from));

        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.success, 'Slot Booked Successfully.');
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Select Slots',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.8),
                fontSize: 20),
          ),
        ),
        floatingActionButton: selectedMeetings.isNotEmpty
            ? SafeArea(
                child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => Dashboard(
                                  isRedirect: true,
                                  index: 1,
                                )),
                      );
                    },
                    label: const Text('View Slots')),
              )
            : null,
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.9,
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
              if (loader)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      );
}

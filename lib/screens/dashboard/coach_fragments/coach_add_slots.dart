import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/time_slots_list_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_add_multiple_slots.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/slots_calendar.dart';
import 'package:nb_utils/nb_utils.dart' as nb;

class CoachMySlots extends StatefulWidget {
  const CoachMySlots({super.key});

  @override
  State<CoachMySlots> createState() => _CoachMySlotsState();
}

class _CoachMySlotsState extends State<CoachMySlots> {
  List<Meeting> globalMeetings = [];
  List<TimeSlotListItem> serverTimeSlotsList = [];
  bool loader = false;

  @override
  void initState() {
    super.initState();
    getAllTimeSlots();
  }

  void addServerTimeSlotsToCalender() {
    setState(() {
      globalMeetings = serverTimeSlotsList
          .map((slot) => Meeting(
              slot.title ?? '',
              DateTime.parse(slot.start!),
              DateTime.parse(slot.end!),
              Colors.green, // Assuming a default color for the meeting
              slot.id ?? -1))
          .toList();
    });
  }

  Future<void> getAllTimeSlots() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await getTimeSlots(appStore.userId ?? -1);
      if (response?.status == true) {
        setState(() {
          serverTimeSlotsList = response?.data ?? [];
        });
        addServerTimeSlotsToCalender();
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong.');
      }
    } catch (e) {
      debugPrint('getAllTimeSlots error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  void handleSingleTimeSlotBooking(DateTime date, DateTime startTime,
      DateTime endTime, String remark) async {
    try {
      var rDate = formatDate(date);
      var rStartTime = formatTime(startTime);
      var rEndTime = formatTime(endTime);

      debugPrint('Date: $rDate');
      debugPrint('Start Time: $rStartTime');
      debugPrint('End Time: $rEndTime');
      debugPrint('Remark: $remark');

      await createSingleTimeSlot(rDate, rStartTime, rEndTime, remark);
    } catch (e) {
      debugPrint('handleSingleTimeSlotBooking error: $e');
    }
  }

  Future<void> createSingleTimeSlot(
      String date, String startTime, String endTime, String remark) async {
    setState(() {
      loader = true;
    });
    try {
      var request = {
        'user_id': appStore.userId,
        'date': date, // '2024/08/02',
        'start_time': startTime, // '16:58',
        'end_time': endTime,
        'remark': remark,
      };

      var response = await createSingleSlot(request);

      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Slot Booked Successfully');
        await getAllTimeSlots();
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong.');
      }
    } catch (e) {
      debugPrint('createSingleTimeSlot error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SlotsCalendar(
            meetings: globalMeetings,
            onSlotSelected: (p0, p1, p2, p3, p4) {
              handleSingleTimeSlotBooking(p0, p1, p2, p3);
            },
          ),
          Positioned(
              bottom: 16,
              right: 16,
              child: AppButton(
                onTap: () async {
                  final list = await Navigator.of(context).push<List<Meeting>>(
                      MaterialPageRoute(
                          builder: (context) => const CoachAddMultipleSlots()));
                  if (list != null) {
                    setState(() {
                      globalMeetings = list;
                    });
                  }
                },
                color: primaryColor,
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Text(
                      'Add Slots',
                      style: nb.boldTextStyle(color: nb.white),
                    ),
                  ],
                ),
              )),
          if (loader)
            const Positioned.fill(
                child: Center(
              child: CircularProgressIndicator(),
            )),
        ],
      );
}

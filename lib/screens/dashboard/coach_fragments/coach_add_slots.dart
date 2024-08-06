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
    getAllTimeSlotsForCoach();
  }

  void addServerTimeSlotsToCalender() {
    setState(() {
      globalMeetings = serverTimeSlotsList
          .map((slot) => Meeting(
              '${slot.status == 1 ? 'Booked - ${slot.title ?? ''}' : slot.title ?? ''}',
              DateTime.parse(slot.start!),
              DateTime.parse(slot.end!),
              slot.status == 1
                  ? Colors.blue
                  : const Color(
                      0xFF0F8644), // Assuming a default color for the meeting
              slot.id ?? -1))
          .toList();
    });
  }

  Future<void> getAllTimeSlotsForCoach() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await getTimeSlotsForCoach(appStore.userId ?? -1);
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

  void handleSingleTimeSlotBooking(
      DateTime date,
      DateTime startTime,
      DateTime endTime,
      String remark,
      int? timeSheetId,
      bool isUpdating) async {
    try {
      var rDate = formatDate(date);
      var rStartTime = formatTime(startTime);
      var rEndTime = formatTime(endTime);

      debugPrint('Date: $rDate');
      debugPrint('Start Time: $rStartTime');
      debugPrint('End Time: $rEndTime');
      debugPrint('Remark: $remark');

      if (!isUpdating) {
        // Only Delete
        await deleteSingleTimeSlot(timeSheetId ?? -1);
      } else {
        // Create or Update
        await createAndUpdateSingleTimeSlot(rDate, rStartTime, rEndTime, remark,
            timeSheetId == 0 ? null : timeSheetId);
      }
    } catch (e) {
      debugPrint('handleSingleTimeSlotBooking error: $e');
    }
  }

  Future<void> createAndUpdateSingleTimeSlot(String date, String startTime,
      String endTime, String remark, int? timeSheetId) async {
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

      var response =
          await createAndUpdateSingleSlot(request, timeSheetId: timeSheetId);

      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Slot Updated Successfully');
        await getAllTimeSlotsForCoach();
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

  Future<void> deleteSingleTimeSlot(int timeSheetId) async {
    setState(() {
      loader = true;
    });
    try {
      var response = await deleteSingleSlot(timeSheetId: timeSheetId);

      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Slot Deleted Successfully');
        await getAllTimeSlotsForCoach();
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong.');
      }
    } catch (e) {
      debugPrint('deleteSingleTimeSlot error: $e');
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
            onSlotSelected: (sDate, sSTime, sETime, sRemark, sMeeting,
                sTimeSheetId, sIsUpdating) {
              handleSingleTimeSlotBooking(
                  sDate, sSTime, sETime, sRemark, sTimeSheetId, sIsUpdating);
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

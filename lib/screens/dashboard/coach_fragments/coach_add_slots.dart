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
  // Map to store error messages for each field
  Map<String, dynamic> fieldErrors = {};

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
          serverTimeSlotsList.clear();
          globalMeetings.clear();
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
      var rStartTime = formatTimeCustom(startTime);
      var rEndTime = formatTimeCustom(endTime);

      debugPrint('Date: $rDate');
      debugPrint('Start Time: $rStartTime');
      debugPrint('End Time: $rEndTime');
      debugPrint('Remark: $remark');

      if (timeSheetId == 0 || timeSheetId == -1) {
        // Create
        await createAndUpdateSingleTimeSlot(
            rDate, rStartTime, rEndTime, remark, null);
      } else {
        if (!isUpdating) {
          // Only Delete
          await deleteSingleTimeSlot(timeSheetId ?? 0);
        } else {
          // Update
          await createAndUpdateSingleTimeSlot(
              rDate,
              rStartTime,
              rEndTime,
              remark,
              (timeSheetId == 0 || timeSheetId == -1) ? null : timeSheetId);
        }
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
        if (response?.errors?.isNotEmpty ?? false) {
          // Set field errors and focus on the first error field
          response?.errors?.forEach((e) {
            fieldErrors[e.field ?? '0'] = e.message ?? '0';
          });
          // Focus on the first error
          if (fieldErrors.containsKey('start_time')) {
            SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
                fieldErrors['start_time'] ?? 'Something went wrong.');
          } else if (fieldErrors.containsKey('end_time')) {
            SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
                fieldErrors['end_time'] ?? 'Something went wrong.');
          } else if (fieldErrors.containsKey('remark')) {
            SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
                fieldErrors['remark'] ?? 'Something went wrong.');
          } else if (fieldErrors.containsKey('date')) {
            SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
                fieldErrors['date'] ?? 'Something went wrong.');
          } else if (fieldErrors.containsKey('user_id')) {
            SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
                fieldErrors['user_id'] ?? 'Something went wrong.');
          }
        } else {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? 'Something went wrong.');
        }
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
              debugPrint(
                  'TimeSheetId: -------------------------------- $sTimeSheetId');
              handleSingleTimeSlotBooking(
                  sDate, sSTime, sETime, sRemark, sTimeSheetId, sIsUpdating);
            },
          ),
          Positioned(
              bottom: 16,
              right: 16,
              child: AppButton(
                onTap: () async {
                  // final list = await Navigator.of(context).push<List<Meeting>>(
                  //     MaterialPageRoute(
                  //         builder: (context) => const CoachAddMultipleSlots()));
                  // if (list != null) {
                  //   setState(() {
                  //     globalMeetings = list;
                  //   });
                  // }
                  var updated = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const CoachAddMultipleSlots()));
                  if (updated) {
                    await getAllTimeSlotsForCoach();
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

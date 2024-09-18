import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SlotsCalendar extends StatefulWidget {
  const SlotsCalendar(
      {super.key,
      required this.meetings,
      required this.onSlotSelected,
      this.onSlotBooking,
      this.startBooking = false});
  final List<Meeting> meetings;
  final void Function(
          DateTime, DateTime, DateTime, String, List<Meeting>, int, bool)
      onSlotSelected;
  final void Function(DateTime, DateTime, DateTime, String, int)? onSlotBooking;
  final bool startBooking;

  @override
  State<SlotsCalendar> createState() => _SlotsCalendarState();
}

class _SlotsCalendarState extends State<SlotsCalendar> {
  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: SfCalendar(
            view: CalendarView.day,
            showNavigationArrow: true,
            showDatePickerButton: true,
            dataSource: MeetingDataSource(widget.meetings),
            onTap: (details) => _onCalendarTapped(
              context: context,
              details: details,
              meetings: widget.meetings,
              onSlotSelected: (selectedDate, startTime, endTime,
                  selectSlotRemark, allSlots, timeSheetId, isUpdating) {
                // Handle the selected slot details and the list of all slots here
                debugPrint('Selected Date: $selectedDate');
                debugPrint('Start Time: $startTime');
                debugPrint('End Time: $endTime');
                debugPrint('Title: $selectSlotRemark');
                for (var i = 0; i < allSlots.length; i++) {
                  debugPrint('${allSlots[i].remark}');
                }
                widget.onSlotSelected(selectedDate, startTime, endTime,
                    selectSlotRemark, allSlots, timeSheetId, isUpdating);
              },
              onSlotBooking: (selectedDate, startTime, endTime, bookSlotRemark,
                  timeSheetId) {
                // Handle the selected slot details and the list of all slots here
                debugPrint('Selected Date: $selectedDate');
                debugPrint('Start Time: $startTime');
                debugPrint('End Time: $endTime');
                debugPrint('Title: $bookSlotRemark');
                if (widget.onSlotBooking != null) {
                  widget.onSlotBooking!(selectedDate, startTime, endTime,
                      bookSlotRemark, timeSheetId);
                }
              },
              startBooking: widget.startBooking,
            ),
            minDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
          ),
        ),
      );

  void _onCalendarTapped({
    required BuildContext context,
    required CalendarTapDetails details,
    required List<Meeting> meetings,
    required void Function(
            DateTime selectedDate,
            DateTime startTime,
            DateTime endTime,
            String selectSlotRemark,
            List<Meeting> allSlots,
            int timeSheetId,
            bool isUpdating)
        onSlotSelected,
    required void Function(
      DateTime selectedDate,
      DateTime startTime,
      DateTime endTime,
      String bookSlotRemark,
      int timeSheetId,
    ) onSlotBooking,
    required bool startBooking,
  }) {
    var currentTime = DateTime.now();

    if (details.targetElement == CalendarElement.calendarCell) {
      if (startBooking) {
        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.warning, 'Not Available for booking.');
      } else {
        var selectedDate = details.date!;
        var startTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedDate.hour,
            selectedDate.minute,
            selectedDate.second);
        var endTime = startTime.add(const Duration(hours: 1));

        // Check if the slot is in the past
        if (startTime.isBefore(currentTime)) {
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.error,
            'Slot is no longer available.',
          );
        } else {
          _showSlotDialog(context, null, selectedDate, startTime, endTime,
              meetings, onSlotSelected);
        }
      }
    } else if (details.targetElement == CalendarElement.appointment) {
      final Meeting meeting = details.appointments?.first;

      // Check if the meeting's start time is in the past
      if (meeting.from.isBefore(currentTime)) {
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.error,
          'This slot has already passed.',
        );
      } else {
        if (startBooking) {
          _showSlotBookingDialog(context, meeting, onSlotBooking);
        } else {
          _showSlotDialog(context, meeting, meeting.from, meeting.from,
              meeting.to, meetings, onSlotSelected);
        }
      }
    }
  }

  void _showSlotBookingDialog(
    BuildContext context,
    Meeting? meeting,
    void Function(DateTime selectedDate, DateTime startTime, DateTime endTime,
            String bookSlotRemark, int timeSheetId)
        onSlotBooking,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text('Book Slots', style: boldTextStyle(size: 18)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Divider(height: 0, color: Colors.black12),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meeting?.remark != null)
                  Text.rich(
                    TextSpan(
                      text: 'Remark : ',
                      style: boldTextStyle(),
                      children: [
                        TextSpan(
                            text:
                                '${meeting!.remark.isEmpty ? 'No Description!' : meeting.remark}',
                            style:
                                const TextStyle(fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
                if (meeting?.remark != null)
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                if (meeting?.remark != null) divider(),
                if (meeting?.remark != null)
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                labelContainer(
                  label: 'Date',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  labelContainerSpace: 8,
                  alignment: Alignment.centerLeft,
                  text:
                      '${meeting?.from.year}-${meeting?.from.month.toString().padLeft(2, '0')}-${meeting?.from.day.toString().padLeft(2, '0')}',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  children: [
                    labelContainer(
                      label: 'Start Time:',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      labelContainerSpace: 8,
                      alignment: Alignment.centerLeft,
                      text:
                          '${DateFormat('hh:mm a').format(DateTime(meeting!.from.year, meeting.from.month, meeting.from.day, meeting.from.hour, meeting.from.minute, meeting.from.second)).toString().padLeft(2, '0')}',
                    ).expand(),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    labelContainer(
                      label: 'End Time:',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      labelContainerSpace: 8,
                      alignment: Alignment.centerLeft,
                      text:
                          '${DateFormat('hh:mm a').format(meeting.to).toString().padLeft(2, '0')}',
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel',
                style: boldTextStyle(size: 16, color: primaryColor)),
          ),
          AppButton(
            onTap: () {
              Navigator.of(context).pop();
              onSlotBooking(meeting!.from, meeting.from, meeting.to,
                  meeting.remark, meeting.timeSheetId);
            },
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360)),
            textColor: white,
            color: primaryColor,
            text: 'Book Slot',
          ),
        ],
      ),
    );
  }

  void _showSlotDialog(
    BuildContext context,
    Meeting? meeting,
    DateTime selectedDate,
    DateTime startTime,
    DateTime endTime,
    List<Meeting> meetings,
    void Function(
            DateTime selectedDate,
            DateTime startTime,
            DateTime endTime,
            String selectSlotRemark,
            List<Meeting> allSlots,
            int timeSheetId,
            bool isUpdating)
        onSlotSelected,
  ) {
    final remarkController = TextEditingController(text: meeting?.remark ?? '');
    var isBooked = meeting != null && meeting.remark.contains('Booked');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text(
                meeting == null
                    ? 'Add Slot'
                    : isBooked
                        ? 'Booked Slot'
                        : 'Edit Slot',
                style: boldTextStyle(size: 18)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Divider(height: 0, color: Colors.black12),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              children: [
                textFormField(
                    controller: remarkController,
                    label: 'Remark',
                    enabled: !isBooked,
                    labelTextBoxSpace: 8,
                    inputFormatters: [
                      NoLeadingSpaceFormatter(),
                    ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                labelContainer(
                  label: 'Date',
                  onTap: () async {
                    if (!isBooked) {
                      var pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startTime,
                        firstDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            DateTime.now().hour,
                            DateTime.now().minute),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          startTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              startTime.hour,
                              startTime.minute);
                          endTime = startTime.add(const Duration(hours: 1));
                        });
                      }
                    }
                  },
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  labelContainerSpace: 8,
                  alignment: Alignment.centerLeft,
                  text:
                      '${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  children: [
                    labelContainer(
                      label: 'Start Time:',
                      onTap: () async {
                        if (!isBooked) {
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: startTime.hour,
                              minute: startTime.minute,
                            ),
                          );
                          if (pickedTime != null) {
                            var newStartTime = DateTime(
                              startTime.year,
                              startTime.month,
                              startTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            var duration = endTime.difference(newStartTime);
                            if (duration.inHours > 1) {
                              // If duration exceeds 1 hour, adjust end time
                              setState(() {
                                endTime =
                                    newStartTime.add(const Duration(hours: 1));
                              });
                            }
                            setState(() {
                              startTime = newStartTime;
                            });
                          }
                        }
                      },
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      labelContainerSpace: 8,
                      alignment: Alignment.centerLeft,
                      text:
                          '${DateFormat('hh:mm a').format(DateTime(startTime.year, startTime.month, startTime.day, startTime.hour, startTime.minute, startTime.second)).toString().padLeft(2, '0')}',
                    ).expand(),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    labelContainer(
                      label: 'End Time:',
                      onTap: () async {
                        if (!isBooked) {
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: endTime.hour,
                              minute: endTime.minute,
                            ),
                          );
                          if (pickedTime != null) {
                            var newEndTime = DateTime(
                              startTime.year,
                              startTime.month,
                              startTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            var duration = newEndTime.difference(startTime);
                            if (duration.inHours > 1) {
                              // If duration exceeds 1 hour, adjust end time
                              setState(() {
                                endTime =
                                    startTime.add(const Duration(hours: 1));
                              });
                            } else {
                              setState(() {
                                endTime = newEndTime;
                              });
                            }
                          }
                        }
                      },
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      labelContainerSpace: 8,
                      alignment: Alignment.centerLeft,
                      text:
                          '${DateFormat('hh:mm a').format(endTime).toString().padLeft(2, '0')}',
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel',
                style: boldTextStyle(size: 16, color: primaryColor)),
          ),
          if (!isBooked && meeting != null)
            AppButton(
              onTap: () {
                setState(() {
                  meetings.remove(meeting);
                });
                Navigator.of(context).pop();
                onSlotSelected(
                    selectedDate,
                    startTime,
                    endTime,
                    remarkController.text.isEmpty
                        ? 'Available Slot'
                        : remarkController.text,
                    meetings,
                    meeting.timeSheetId,
                    false);
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360)),
              textColor: white,
              color: primaryColor,
              text: 'Delete Slot',
            ),
          if (!isBooked)
            AppButton(
              onTap: () {
                // **Add Overlap Check Here**
                if (!_isSlotOverlapping(
                    meetings, startTime, endTime, meeting)) {
                  var remarkText = remarkController.text.isEmpty
                      ? 'Available Slot'
                      : remarkController.text;
                  onSlotSelected(selectedDate, startTime, endTime, remarkText,
                      meetings, meeting?.timeSheetId ?? 0, true);
                  Navigator.of(context).pop();
                } else {
                  SnackBarHelper.showStatusSnackBar(
                      context,
                      StatusIndicator.error,
                      'Selected slot overlaps with an existing slot.');
                }
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360)),
              textColor: white,
              color: primaryColor,
              text: 'Save Slot',
            ),
        ],
      ),
    );
  }

  bool _isSlotOverlapping(List<Meeting> meetings, DateTime startTime,
      DateTime endTime, Meeting? meeting) {
    for (var existingMeeting in meetings) {
      if (meeting != null && existingMeeting == meeting) continue;
      if (startTime.isBefore(existingMeeting.to) &&
          endTime.isAfter(existingMeeting.from)) {
        return true;
      }
    }
    return false;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => _getMeetingData(index).from;

  @override
  DateTime getEndTime(int index) => _getMeetingData(index).to;

  @override
  String getSubject(int index) => _getMeetingData(index).remark;

  @override
  Color getColor(int index) => DateTime.parse(_getMeetingData(index).from.toString()).isBefore(DateTime.now()) ? gray : _getMeetingData(index).background;

  int getTimeSheetId(int index) => _getMeetingData(index).timeSheetId;

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }
    return meetingData;
  }
}

class Meeting {
  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        json['eventName'],
        DateTime.parse(json['from']),
        DateTime.parse(json['to']),
        Color(int.parse(json['background'])),
        json['timeSheetId'] ?? 0,
      );
  Meeting(this.remark, this.from, this.to, this.background, this.timeSheetId);

  String remark;
  DateTime from;
  DateTime to;
  Color background;
  int timeSheetId;
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/screens/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Represents a meeting or slot in the calendar.
class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

/// Data source for the calendar using the Syncfusion calendar package.
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => _getMeetingData(index).from;

  @override
  DateTime getEndTime(int index) => _getMeetingData(index).to;

  @override
  String getSubject(int index) => _getMeetingData(index).eventName;

  @override
  Color getColor(int index) => _getMeetingData(index).background;

  @override
  bool isAllDay(int index) => _getMeetingData(index).isAllDay;

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }
    return meetingData;
  }
}

/// Widget for displaying a calendar with slots/meetings and handling slot selection.
class SlotsCalendar extends StatefulWidget {
  final List<Meeting> meetings;
  final void Function(DateTime, DateTime, DateTime, String, List<Meeting>)
      onSlotSelected;

  const SlotsCalendar({
    Key? key,
    required this.meetings,
    required this.onSlotSelected,
  }) : super(key: key);

  @override
  State<SlotsCalendar> createState() => _SlotsCalendarState();
}

class _SlotsCalendarState extends State<SlotsCalendar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            onSlotSelected: widget.onSlotSelected,
          ),
          minDate: DateTime.now(),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          ),
        ),
      ),
    );
  }

  /// Handles tap events on the calendar.
  void _onCalendarTapped({
    required BuildContext context,
    required CalendarTapDetails details,
    required List<Meeting> meetings,
    required void Function(DateTime, DateTime, DateTime, String, List<Meeting>)
        onSlotSelected,
  }) {
    if (details.targetElement == CalendarElement.calendarCell) {
      var selectedDate = details.date!;
      var startTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedDate.hour,
        selectedDate.minute,
        selectedDate.second,
      );
      var endTime = startTime.add(const Duration(hours: 1));
      _showSlotDialog(context, null, selectedDate, startTime, endTime, meetings,
          onSlotSelected);
    } else if (details.targetElement == CalendarElement.appointment) {
      final Meeting meeting = details.appointments!.first;
      _showSlotDialog(context, meeting, meeting.from, meeting.from, meeting.to,
          meetings, onSlotSelected);
    }
  }

  /// Shows a dialog for adding/editing a slot.
  void _showSlotDialog(
    BuildContext context,
    Meeting? meeting,
    DateTime selectedDate,
    DateTime startTime,
    DateTime endTime,
    List<Meeting> meetings,
    void Function(DateTime, DateTime, DateTime, String, List<Meeting>)
        onSlotSelected,
  ) {
    final titleController =
        TextEditingController(text: meeting?.eventName ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text(meeting == null ? 'Add Slot' : 'Edit Slot',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Divider(height: 0, color: Colors.black12),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ListTile(
                  title: const Text('Date:'),
                  subtitle: Text(
                    '${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                  ),
                  onTap: () async {
                    var pickedDate = await showDatePicker(
                      context: context,
                      initialDate: startTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        startTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          startTime.hour,
                          startTime.minute,
                        );
                        endTime = startTime.add(const Duration(hours: 1));
                      });
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Start Time:'),
                        subtitle: Text(
                          '${DateFormat('hh:mm a').format(startTime)}',
                        ),
                        onTap: () async {
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(startTime),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              startTime = DateTime(
                                startTime.year,
                                startTime.month,
                                startTime.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              endTime = startTime.add(const Duration(hours: 1));
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('End Time:'),
                        subtitle: Text(
                          '${DateFormat('hh:mm a').format(endTime)}',
                        ),
                        onTap: () async {
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(endTime),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              endTime = DateTime(
                                endTime.year,
                                endTime.month,
                                endTime.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              startTime = endTime.subtract(const Duration(hours: 1));
                            });
                          }
                        },
                      ),
                    ),
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
          if (meeting != null)
            AppButton(
              onTap: () {
                setState(() {
                  meetings.remove(meeting);
                });
                Navigator.of(context).pop();
                onSlotSelected(selectedDate, startTime, endTime,
                    titleController.text, meetings);
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360)),
              textColor: white,
              color: primaryColor,
              text: 'Delete Slot',
            ),
          AppButton(
            onTap: () {
              var title = titleController.text.isEmpty
                  ? 'Available Slot'
                  : titleController.text;

              
              if (endTime.difference(startTime).inHours > 1) {
                // If duration exceeds 1 hour, show an error or adjust automatically
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Slot duration cannot exceed 1 hour.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                if (meeting == null) {
                  setState(() {
                    meetings.add(Meeting(title, startTime, endTime,
                        const Color(0xFF0F8644), false));
                  });
                } else {
                  setState(() {
                    final index = meetings.indexOf(meeting);
                    meetings[index] = Meeting(title, startTime, endTime,
                        const Color(0xFF0F8644), false);
                  });
                }
                Navigator.of(context).pop();
                onSlotSelected(
                    selectedDate, startTime, endTime, title, meetings);
              }
            },
            padding: EdgeInsets.zero,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360)),
            textColor: white,
            color: primaryColor,
            text: meeting == null ? 'Add' : 'Save',
          ),
        ],
      ),
    );
  }
}

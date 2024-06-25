import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/screens/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CoachAddSlots extends StatefulWidget {
  const CoachAddSlots({super.key});

  @override
  State<CoachAddSlots> createState() => _CoachAddSlotsState();
}

class _CoachAddSlotsState extends State<CoachAddSlots> {
  List<Meeting> globalMeetings = [];

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

class SlotsCalendar extends StatefulWidget {
  const SlotsCalendar(
      {super.key, required this.meetings, required this.onSlotSelected});
  final List<Meeting> meetings;
  final void Function(DateTime, DateTime, DateTime, String, List<Meeting>)
      onSlotSelected;

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
              onSlotSelected:
                  (selectedDate, startTime, endTime, title, allSlots) {
                // Handle the selected slot details and the list of all slots here
                debugPrint('Selected Date: $selectedDate');
                debugPrint('Start Time: $startTime');
                debugPrint('End Time: $endTime');
                debugPrint('Title: $title');
                for (var i = 0; i < allSlots.length; i++) {
                  debugPrint('${allSlots[i].eventName}');
                }
              },
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
    required void Function(DateTime selectedDate, DateTime startTime,
            DateTime endTime, String title, List<Meeting> allSlots)
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
          selectedDate.second);
      var endTime = startTime.add(const Duration(hours: 1));
      _showSlotDialog(context, null, selectedDate, startTime, endTime, meetings,
          onSlotSelected);
    } else if (details.targetElement == CalendarElement.appointment) {
      final Meeting meeting = details.appointments!.first;
      _showSlotDialog(context, meeting, meeting.from, meeting.from, meeting.to,
          meetings, onSlotSelected);
    }
  }

  void _showSlotDialog(
    BuildContext context,
    Meeting? meeting,
    DateTime selectedDate,
    DateTime startTime,
    DateTime endTime,
    List<Meeting> meetings,
    void Function(DateTime selectedDate, DateTime startTime, DateTime endTime,
            String title, List<Meeting> allSlots)
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
                    controller: titleController,
                    label: 'Title',
                    labelTextBoxSpace: 8),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                labelContainer(
                  label: 'Date',
                  onTap: () async {
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
                        startTime = DateTime(pickedDate.year, pickedDate.month,
                            pickedDate.day, startTime.hour, startTime.minute);
                        endTime = startTime.add(const Duration(hours: 1));
                      });
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
                              endTime = startTime.add(const Duration(hours: 1));
                            });
                          } else {
                            setState(() {
                              endTime = newEndTime;
                            });
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

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

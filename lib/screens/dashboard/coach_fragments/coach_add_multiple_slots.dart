import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:jumpvalues/widgets/slots_calendar.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachAddMultipleSlots extends StatefulWidget {
  const CoachAddMultipleSlots({super.key});

  @override
  State<CoachAddMultipleSlots> createState() => _CoachAddMultipleSlotsState();
}

class _CoachAddMultipleSlotsState extends State<CoachAddMultipleSlots> {
  List<Meeting> globalMeetings = [];
  DateTimeRange? selectedDateRange;
  List<int> selectedWeekdays = [];
  List<TimeSlot> selectedTimeSlots = [];

  // Method to add or remove a meeting based on selected slot
  void handleSlotSelection(DateTime selectedDate, DateTime startTime,
      DateTime endTime, String remark) {
    setState(() {
      globalMeetings.add(
        Meeting(remark, startTime, endTime, const Color(0xFF0F8644)),
      );
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
            'Add Slots',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.8),
                fontSize: 20),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: selectedDateRange != null &&
                    selectedWeekdays.isNotEmpty &&
                    selectedTimeSlots.isNotEmpty
                ? _createSlots
                : null,
            label: const Text('Create Slots')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              // globalMeetings.isNotEmpty
              //     ? Expanded(
              //         child: SfCalendar(
              //           view: CalendarView.day,
              //           showNavigationArrow: true,
              //           showDatePickerButton: true,
              //           dataSource: MeetingDataSource(globalMeetings),
              //         ),
              //       )
              //     :
              SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelContainer(
                  label: 'Pick Date Range',
                  labelContainerSpace: 8,
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.055,
                  borderRadius: BorderRadius.circular(12),
                  alignment: Alignment.centerLeft,
                  text: selectedDateRange != null
                      ? '${DateFormat('dd MMM yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy').format(selectedDateRange!.end)}'
                      : 'Tap to Pick Date Range',
                  onTap: () async {
                    final pickedRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (pickedRange != null) {
                      setState(() {
                        selectedDateRange = pickedRange;
                      });
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                const Text(
                  'Select Weekdays:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: boxDecorationDefault(
                    color: primaryColor,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 1; i <= 7; i++)
                          FilterChip(
                            label: SizedBox(
                              width: 25,
                              height: 25,
                              child: Text(
                                DateFormat.E().format(DateTime(
                                    selectedDateRange != null
                                        ? selectedDateRange!.start.year
                                        : DateTime.now().year,
                                    selectedDateRange != null
                                        ? selectedDateRange!.start.month
                                        : DateTime.now().month,
                                    i)),
                                style: const TextStyle(fontSize: 12),
                              ).center(),
                            ),
                            selected: selectedWeekdays.contains(i),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: transparentColor),
                                borderRadius: BorderRadius.circular(360)),
                            labelPadding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: primaryColor,
                            labelStyle: const TextStyle(color: white),
                            selectedColor: primaryColor.withOpacity(0.7),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedWeekdays.add(i);
                                  debugPrint('Selected Day: Int value $i');
                                } else {
                                  selectedWeekdays.remove(i);
                                }
                              });
                            },
                          ).paddingRight(10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                labelContainer(
                  label: 'Pick Time Range',
                  labelContainerSpace: 8,
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.055,
                  borderRadius: BorderRadius.circular(12),
                  alignment: Alignment.centerLeft,
                  text: 'Tap to pick date',
                  onTap: () async {
                    final selectedTimes = await showTimeRangePicker(context);
                    if (selectedTimes.isNotEmpty) {
                      setState(() {
                        selectedTimeSlots.addAll(selectedTimes);
                      });
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 15,
                        mainAxisExtent: 50),
                    itemCount: selectedTimeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = selectedTimeSlots[index];
                      return FilterChip(
                          label: Text(
                            '${slot.startTime.format(context)} - ${slot.endTime.format(context)}',
                            style: TextStyle(fontSize: 14),
                          ),
                          deleteIcon: Icon(
                            Icons.cancel,
                            color: redColor,
                            size: 20,
                          ),
                          visualDensity: VisualDensity.standard,
                          onDeleted: () {
                            setState(() {
                              selectedTimeSlots.removeAt(index);
                            });
                          },
                          onSelected: (v) {});
                    }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ),
      );

  Future<List<TimeSlot>> showTimeRangePicker(BuildContext context) async {
    final pickedStartTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 1, minute: 0),
    );

    if (pickedStartTime != null) {
      final pickedEndTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: pickedStartTime.hour + 1, minute: pickedStartTime.minute),
      );

      if (pickedEndTime != null) {
        // Calculate number of 1-hour slots between pickedStartTime and pickedEndTime
        final List<TimeSlot> slots = [];
        DateTime currentSlotStart = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedStartTime.hour,
          pickedStartTime.minute,
        );

        while (currentSlotStart.isBefore(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedEndTime.hour,
          pickedEndTime.minute,
        ))) {
          final currentSlotEnd = currentSlotStart.add(Duration(hours: 1));
          slots.add(TimeSlot(
            startTime: TimeOfDay.fromDateTime(currentSlotStart),
            endTime: TimeOfDay.fromDateTime(currentSlotEnd),
          ));
          currentSlotStart = currentSlotEnd;
        }

        return slots;
      }
    }

    return [];
  }

  void _createSlots() {
    final slots = <Meeting>[];

    final startDate = selectedDateRange!.start;
    final endDate = selectedDateRange!.end;

    for (var day = startDate;
        day.isBefore(endDate) || day.isAtSameMomentAs(endDate);
        day = day.add(const Duration(days: 1))) {
      if (selectedWeekdays.contains(day.weekday)) {
        for (var slot in selectedTimeSlots) {
          final startDateTime = DateTime(day.year, day.month, day.day,
              slot.startTime.hour, slot.startTime.minute);
          final endDateTime = startDateTime.add(const Duration(hours: 1));
          slots.add(Meeting('Available Slot', startDateTime, endDateTime,
              const Color(0xFF0F8644)));
        }
      }
    }

    Navigator.pop(context, slots); // Returning the list directly
  }
}

class TimeSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeSlot({required this.startTime, required this.endTime});
}

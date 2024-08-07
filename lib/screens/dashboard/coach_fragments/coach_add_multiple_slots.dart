import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart' as util;
import 'package:jumpvalues/utils/utils.dart';
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
  bool loader = false;
  TextEditingController remarkController = TextEditingController();
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();

  String? remarkErrorText;

  bool isDateRangeError = false;
  String? dateRangeErrorText;

  bool isWeekDaysError = false;
  String? weekDaysErrorText;

  bool isTimeRangeError = false;
  String? timeRangeErrorText;

  bool isSelectedAllWeekdays = false;

  final List<String> weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  void handleSlotSelection(DateTime selectedDate, DateTime startTime,
      DateTime endTime, String remark) {
    setState(() {
      globalMeetings.add(
        Meeting(remark, startTime, endTime, const Color(0xFF0F8644), 1),
      );
    });
  }

  void validateAndCreateSlots() {
    setState(() {
      isDateRangeError = selectedDateRange == null;
      dateRangeErrorText = isDateRangeError ? 'Please pick date range' : null;

      isWeekDaysError = selectedWeekdays.isEmpty;
      weekDaysErrorText =
          isWeekDaysError ? 'Select at least one week day' : null;

      isTimeRangeError = selectedTimeSlots.isEmpty;
      timeRangeErrorText = isTimeRangeError ? 'Please pick time range' : null;

      remarkErrorText =
          remarkController.text.isEmpty ? 'Remark should not be empty' : null;

      if (!isDateRangeError &&
          !isWeekDaysError &&
          !isTimeRangeError &&
          (remarkErrorText == null)) {
        hideKeyboard(context);
        createAndUpdateSingleTimeSlot();
      }
    });
  }

  Future<void> createAndUpdateSingleTimeSlot() async {
    setState(() {
      loader = true;
    });
    try {
      var request = {
        'start_date':
            util.formatDate(selectedDateRange?.start ?? DateTime.now()),
        'end_date': util.formatDate(selectedDateRange?.end ?? DateTime.now()),
        'start_time': util.formatTime(selectedStartTime),
        'end_time': util.formatTime(selectedEndTime),
        'remark': remarkController.text,
        'selected_days': selectedWeekdays,
      };

      var response = await createMultipleSlot(request);

      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Slot Updated Successfully');
        Navigator.of(context).pop(true);
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
          onPressed: validateAndCreateSlots,
          label: const Text('Create Slots'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textFormField(
                      label: 'Remark',
                      controller: remarkController,
                      errorText: remarkErrorText,
                      hintText: 'Enter Remark',
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    labelContainer(
                      label: 'Pick Date Range',
                      labelContainerSpace: 8,
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.055,
                      borderRadius: BorderRadius.circular(12),
                      alignment: Alignment.centerLeft,
                      errorText: dateRangeErrorText,
                      isError: isDateRangeError,
                      text: selectedDateRange != null
                          ? '${DateFormat('dd MMM yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy').format(selectedDateRange!.end)}'
                          : 'Tap to Pick Date Range',
                      onTap: () async {
                        hideKeyboard(context);
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Weekdays:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'All',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Checkbox(
                              value: isSelectedAllWeekdays,
                              onChanged: (v) {
                                setState(() {
                                  hideKeyboard(context);
                                  isSelectedAllWeekdays = v ?? false;
                                  selectedWeekdays.clear();
                                  if (isSelectedAllWeekdays) {
                                    selectedWeekdays
                                        .addAll([0, 1, 2, 3, 4, 5, 6]);
                                  }
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    labelContainer(
                      isLabel: false,
                      label: '',
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.06,
                      isError: isWeekDaysError,
                      errorText: weekDaysErrorText,
                      color: primaryColor,
                      padding: EdgeInsets.zero,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: weekdays.asMap().entries.map((entry) {
                            var idx = entry.key;
                            var weekday = entry.value;
                            return FilterChip(
                              label: SizedBox(
                                width: 25,
                                height: 25,
                                child: Text(
                                  weekday,
                                  style: const TextStyle(fontSize: 12),
                                ).center(),
                              ),
                              selected: selectedWeekdays.contains(idx),
                              showCheckmark: false,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: transparentColor),
                                borderRadius: BorderRadius.circular(360),
                              ),
                              labelPadding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: primaryColor,
                              labelStyle: const TextStyle(color: white),
                              selectedColor: primaryColor.withOpacity(0.7),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedWeekdays.add(idx);
                                  } else {
                                    selectedWeekdays.remove(idx);
                                  }
                                });
                              },
                            ).paddingRight(10);
                          }).toList(),
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
                      isError: isTimeRangeError,
                      errorText: timeRangeErrorText,
                      text: 'Tap to pick date',
                      onTap: () async {
                        hideKeyboard(context);
                        final selectedTimes =
                            await showTimeRangePicker(context);
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 15,
                        mainAxisExtent: 50,
                      ),
                      itemCount: selectedTimeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = selectedTimeSlots[index];
                        return FilterChip(
                          label: Text(
                            '${slot.startTime.format(context)} - ${slot.endTime.format(context)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          deleteIcon: const Icon(
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
                          onSelected: (v) {},
                        );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              ),
            ),
            if (loader)
              const Positioned(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
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
        // =========================================================================
        var startDate = selectedDateRange != null
            ? selectedDateRange?.start
            : DateTime.now();
        try {
          selectedStartTime = DateTime(startDate!.year, startDate.month,
              startDate.day, pickedStartTime.hour, pickedStartTime.minute);

          selectedEndTime = DateTime(startDate.year, startDate.month,
              startDate.day, pickedEndTime.hour, pickedEndTime.minute);
        } catch (e) {
          debugPrint('showTimeRangePicker error: $e');
        }
        // =========================================================================

        // Calculate number of 1-hour slots between pickedStartTime and pickedEndTime
        final slots = <TimeSlot>[];
        var currentSlotStart = DateTime(
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
          final currentSlotEnd = currentSlotStart.add(const Duration(hours: 1));
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
              const Color(0xFF0F8644), 1));
        }
      }
    }

    Navigator.pop(context, slots); // Returning the list directly
  }
}

class TimeSlot {
  TimeSlot({required this.startTime, required this.endTime});
  final TimeOfDay startTime;
  final TimeOfDay endTime;
}

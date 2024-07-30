import 'package:flutter/material.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_add_multiple_slots.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/widgets/slots_calendar.dart';
import 'package:nb_utils/nb_utils.dart' as nb;

class CoachMySlots extends StatefulWidget {
  const CoachMySlots({super.key});

  @override
  State<CoachMySlots> createState() => _CoachMySlotsState();
}

class _CoachMySlotsState extends State<CoachMySlots> {
  List<Meeting> globalMeetings = [];

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SlotsCalendar(
            meetings: globalMeetings,
            onSlotSelected: (p0, p1, p2, p3, p4) {},
          ),
          Positioned(
              bottom: 16,
              right: 16,
              child: AppButton(
                onTap: () async {
                  final list = await Navigator.of(context).push<List<Meeting>>(MaterialPageRoute(
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
              ))
        ],
      );
}

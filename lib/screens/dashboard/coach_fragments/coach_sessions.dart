import 'package:flutter/material.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachSessions extends StatefulWidget {
  const CoachSessions({super.key});

  @override
  State<CoachSessions> createState() => _CoachSessionsState();
}

class _CoachSessionsState extends State<CoachSessions> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 2,
          separatorBuilder: (context, index) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          itemBuilder: (context, index) => BookingItemComponent(
            showButtons: true,
          ),
        ).paddingSymmetric(horizontal: 16, vertical: 16),
      );
}

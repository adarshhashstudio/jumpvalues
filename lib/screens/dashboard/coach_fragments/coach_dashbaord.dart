import 'package:flutter/material.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  @override
  void initState() {
    isTokenAvailable(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                todaySession(context, total: '5'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TotalWidget(
                        icon: icUpcoming,
                        title: 'Upcoming Sessions',
                        total: '10',
                        color: white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Expanded(
                      child: TotalWidget(
                        icon: icCompleted,
                        title: 'Completed Sessions',
                        total: '8',
                        color: white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                // Row(
                //   children: [
                //     Text('Recent Requests ', style: boldTextStyle()),
                //   ],
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.02,
                // ),
              ],
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:jumpvalues/screens/utils/images.dart';
import 'package:jumpvalues/screens/utils/utils.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
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
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TotalWidget(
                        icon: icUpcoming,
                        title: 'Upcoming Sessions',
                        total: '4',
                        color: white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Expanded(
                      child: TotalWidget(
                        icon: icCompleted,
                        title: 'Completed Sessions',
                        total: '10',
                        color: white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  children: [
                    Text('Recent Requests', style: boldTextStyle()),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 2,
                  separatorBuilder: (context, index) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  itemBuilder: (context, index) => BookingItemComponent(showButtons: false,),
                ),
              ],
            ),
          ),
        ),
      );
}

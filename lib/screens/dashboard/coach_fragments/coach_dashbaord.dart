import 'package:flutter/material.dart';
import 'package:jumpvalues/models/coach_dashboard_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/dashboard/booking_item_component.dart';
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
  bool loader = false;
  CoachDashboardResponseModel? coachDashboardResponseModel;

  @override
  void initState() {
    isTokenAvailable(context);
    getCoachDashboard();
    super.initState();
  }

  Future<void> getCoachDashboard() async {
    setState(() {
      loader = true;
    });

    try {
      var response = await coachDashboard();

      if (response?.status == true) {
        setState(() {
          coachDashboardResponseModel = response;
        });
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('getCoachDashboard error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    todaySession(context,
                        total:
                            '${coachDashboardResponseModel?.data?.todaySessions ?? '0'}'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TotalWidget(
                            icon: icUpcoming,
                            title: 'Upcoming Sessions',
                            total:
                                '${coachDashboardResponseModel?.data?.upcomingSessions ?? '0'}',
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
                            total:
                                '${coachDashboardResponseModel?.data?.completedSessions ?? '0'}',
                            color: white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Row(
                      children: [
                        Text('Recent Requests ', style: boldTextStyle()),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: coachDashboardResponseModel
                                ?.data?.recentRequests?.length ??
                            0,
                        separatorBuilder: (context, index) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                        itemBuilder: (context, index) => BookingItemComponent(
                              showButtons: false,
                              serviceResource: coachDashboardResponseModel
                                  ?.data?.recentRequests?[index],
                              index: index,
                              onActionPerformed: () {},
                            )),
                  ],
                ),
              ),
            ),
          ),
          if (loader)
            const Positioned.fill(
                child: Center(
              child: CircularProgressIndicator(),
            ))
        ],
      );
}

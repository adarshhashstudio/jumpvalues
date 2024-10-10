import 'package:flutter/material.dart';
import 'package:jumpvalues/models/coach_dashboard_response_model.dart';
import 'package:jumpvalues/models/tutorial_video_modle.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/dashboard/tutorial_video_module.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  bool loader = false;
  CoachDashboardResponseModel? coachDashboardResponseModel;
  List<VideoRow>? videos = [];

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
          if (coachDashboardResponseModel?.data?.videos?.count != null) {
            videos = coachDashboardResponseModel?.data?.videos?.rows;
          }
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

  Future<void> _refreshData() async {
    isTokenAvailable(context);
    await getCoachDashboard();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          RefreshIndicator(
            onRefresh:
                _refreshData, // Define this function to refresh your data
            child: ListView(
              padding: const EdgeInsets.all(16.0),
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
                buildVideoListWidget(context),
              ],
            ),
          ),
          if (loader)
            const Positioned.fill(
                child: Center(
              child: CircularProgressIndicator(),
            )),
        ],
      );

  Widget buildVideoListWidget(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width * 1,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.1,
        ),
        decoration: boxDecorationDefault(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tutorial Videos',
                      style: boldTextStyle(),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
            // (videos == null || videos!.isEmpty)
            //     ? dataNotFoundWidget(context, showImage: false).onTap(() {})
            //     : ListView.builder(
            //         itemCount: videos?.length,
            //         physics: const NeverScrollableScrollPhysics(),
            //         shrinkWrap: true,
            //         itemBuilder: (context, index) {
            //           final video = videos?[index];
            //           return ListTile(
            //             leading: IconButton(
            //               icon: const Icon(Icons.video_file, size: 35),
            //               onPressed: () {},
            //             ),
            //             trailing: const Icon(
            //               Icons.arrow_right,
            //               size: 30,
            //             ),
            //             contentPadding: EdgeInsets.zero,
            //             dense: true,
            //             title: Text(video?.title ?? ''),
            //             subtitle: Text(video?.slug ?? ''),
            //             onTap: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => VideoPlayerScreen(
            //                     videoUrl: video?.url ?? '',
            //                     title: video?.title ?? '',
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         },
            //       ),
            TutorialVideoModule(videos: videos),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 16),
      );
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/client_dashboard_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/client_screens/select_screen.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_all_coaches.dart';
import 'package:jumpvalues/screens/dashboard/video_player_screen.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/store/goals_data_hive.dart';
import 'package:jumpvalues/store/goals_store.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  final goalsStore = GoalsStore(goalsBox, appStore.userId.toString());
  bool loader = false;
  ClientDashboardResponseModel? clientDashboardResponseModel;
  List<VideoRow>? videos = [];

  @override
  void initState() {
    isTokenAvailable(context);
    getClientDashboard();
    goalsStore.loadGoals();
    super.initState();
  }

  Future<void> getClientDashboard() async {
    setState(() {
      loader = true;
    });

    try {
      var response = await clientDashboard();

      if (response?.status == true) {
        setState(() {
          clientDashboardResponseModel = response;
          if (clientDashboardResponseModel?.data?.client?.videos?.count !=
              null) {
            videos = clientDashboardResponseModel?.data?.client?.videos?.rows;
          }
        });
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('getClientDashboard error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> _refreshData() async {
    isTokenAvailable(context);
    await getClientDashboard();
    goalsStore.loadGoals();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        gradientContainer(context,
                            startColor: const Color(0xFFF69273),
                            endColor: const Color(0xFFFF6E7A),
                            icon: learnImage,
                            title:
                                'Start your Journey by learning more about personal values.',
                            buttonTitle: 'Learn ( Values )', onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const WebViewScreen(
                                    url: learnSectionUrl,
                                  )));
                        }),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.035,
                        ),
                        gradientContainer(context,
                            startColor: const Color(0xFF95cfd3),
                            endColor: const Color(0xFF96d3c5),
                            icon: selectImage,
                            title:
                                'Click to select your values from our comprehensive list.',
                            buttonTitle: 'Select ( Values )', onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SelectScreen(
                                  isFromProfile: false,
                                  initialSelectedValues:
                                      clientDashboardResponseModel
                                              ?.data?.client?.coreValues ??
                                          [])));
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  if (appStore.additionalSponsor.isNotEmpty)
                    button(context, onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const ClientAllCoaches()));
                      var check = clientDashboardResponseModel
                              ?.data?.client?.consentRaised ??
                          false;
                      if (!check) {
                        if (appStore.additionalSponsor.isNotEmpty) {
                          showUpgradeSponsorshipDialog(context,
                              onActionPerformed: () async {
                            await _refreshData();
                          });
                        }
                      }
                    },
                        color: (clientDashboardResponseModel
                                    ?.data?.client?.consentRaised ??
                                false)
                            ? greenColor
                            : null,
                        text: (clientDashboardResponseModel
                                    ?.data?.client?.consentRaised ??
                                false)
                            ? 'You have already raised consent...'
                            : 'Your Personal Coaching Portal',
                        borderRadius: BorderRadius.circular(8)),
                  if (appStore.additionalSponsor.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                  buildGoalsWidget(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  buildVideoListWidget(context),
                ],
              ),
            ],
          ),
        ),
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
            (videos == null || videos!.isEmpty)
                ? dataNotFoundWidget(context, showImage: false).onTap(() {})
                : ListView.builder(
                    itemCount: videos?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final video = videos?[index];
                      return ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.video_file, size: 35),
                          onPressed: () {},
                        ),
                        trailing: const Icon(
                          Icons.arrow_right,
                          size: 30,
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(video?.title ?? ''),
                        subtitle: Text(video?.slug ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoUrl: video?.url ?? '',
                                title: video?.title ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 16),
      );

  Observer buildGoalsWidget(BuildContext context) => Observer(
      builder: (_) => Container(
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
                          'My Goals',
                          style: boldTextStyle(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Add',
                              style: boldTextStyle(color: primaryColor),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Icon(
                              Icons.edit_note,
                              color: primaryColor,
                            ),
                          ],
                        ).onTap(() async {
                          await showAddGoalsDialogue(context);
                        })
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
                goalsStore.goalsList.isEmpty
                    ? dataNotFoundWidget(context,
                            text:
                                'Write Your Goals, Watch Your Life Grow.\nEg. Procrastination, Confidence,...')
                        .onTap(() async {
                        await showAddGoalsDialogue(context);
                      })
                    : ListView.separated(
                        itemCount: goalsStore.goalsList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        itemBuilder: (context, index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${index + 1}. ${goalsStore.goalsList[index].goalName}',
                              style: TextStyle(
                                  decoration:
                                      goalsStore.goalsList[index].goalSelected
                                          ? TextDecoration.lineThrough
                                          : null),
                            ).expand(),
                            Icon(
                              goalsStore.goalsList[index].goalSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank_outlined,
                              color: greenColor.withOpacity(0.5),
                              size: 20,
                            ).onTap(() {
                              setState(() {
                                goalsStore
                                    .toggleGoal(goalsStore.goalsList[index]);
                              });
                            }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Icon(
                              Icons.delete_rounded,
                              color: redColor.withOpacity(0.5),
                              size: 20,
                            ).onTap(() {
                              setState(() {
                                goalsStore
                                    .removeGoal(goalsStore.goalsList[index]);
                              });
                            }),
                          ],
                        ),
                      ),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 16),
          ));

  Future<void> showAddGoalsDialogue(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        var goalController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Column(
            children: [
              Text(
                'Add Goals (Max. 5 Goals Allowed)',
                style: boldTextStyle(),
              ).center(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              divider(),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  textFormField(
                    label: '',
                    controller: goalController,
                    isLabel: false,
                    maxLines: 3,
                    hintText: 'Enter Your Goal',
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      button(context, onPressed: () {
                        Navigator.of(context).pop();
                      }, isBordered: true, text: 'Cancel')
                          .expand(),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      button(context, onPressed: () {
                        if (goalsStore.goalsList.length > 4) {
                          SnackBarHelper.showStatusSnackBar(
                              context,
                              StatusIndicator.error,
                              'Maximum 5 goals are allowed.');
                        } else {
                          if (goalController.text == '') {
                            SnackBarHelper.showStatusSnackBar(
                                context,
                                StatusIndicator.error,
                                'Goal text should not be empty.');
                          } else {
                            setState(() {
                              var newGoal = GoalsData(
                                goalId: Random().nextInt(100),
                                goalName: goalController.text,
                                userId: appStore.userId
                                    .toString(), // Set the userId for the goal
                              );

                              goalsStore.addGoal(newGoal);
                            });
                            Navigator.of(context).pop();
                            SnackBarHelper.showStatusSnackBar(
                                context,
                                StatusIndicator.success,
                                'Goal Added Successfully!!');
                          }
                        }
                      }, text: 'Add')
                          .expand(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ).then((v) {
      setState(() {});
    });
  }

  Widget gradientContainer(BuildContext context,
          {required Color startColor,
          required Color endColor,
          void Function()? onTap,
          required String icon,
          required String title,
          required String buttonTitle}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.44,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
                colors: [
                  startColor,
                  endColor,
                ],
                begin: const FractionalOffset(1.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    icon,
                    width: MediaQuery.of(context).size.width * 0.10,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  IconButton(
                    onPressed: onTap,
                    icon: const Icon(
                      Icons.arrow_circle_right,
                      size: 40,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ).withHeight(MediaQuery.of(context).size.height * 0.11),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.7)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

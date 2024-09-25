import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_all_coaches.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_dashbaord.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_sessions.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_add_slots.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_dashbaord.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_sessions.dart';
import 'package:jumpvalues/screens/dashboard/common_profile.dart';
import 'package:jumpvalues/screens/notification_page.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/string_extensions.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class Dashboard extends StatefulWidget {
  Dashboard({this.index, this.isRedirect = false});
  final int? index;
  final bool isRedirect;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  bool loader = false;

  DateTime? currentBackPressTime;

  List<String> screenName = [];

  void switchToFragment(int index, {String? statusType}) {
    currentIndex = index;
    setState(() {});
  }

  late List<Widget> fragmentList = [];

  @override
  void initState() {
    super.initState();
    fragmentList = [
      appStore.userTypeCoach ? const CoachDashboard() : const ClientDashboard(),
      if (appStore.additionalSponsor.isEmpty)
        appStore.userTypeCoach ? const CoachSessions() : const ClientSessions(),
      if (appStore.additionalSponsor.isEmpty)
        appStore.userTypeCoach
            ? const CoachMySlots()
            : const ClientAllCoaches(),
      const CommonProfile(),
    ];
    init();
  }

  Future<void> init() async {
    if (widget.isRedirect.validate(value: false)) {
      currentIndex = widget.index ?? 1;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showLogoutConfirmationDialog(BuildContext outerContext) {
    showDialog(
      context: outerContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('You want to logout now?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              isTokenAvailable(context);
              // Call the code to clear the token and navigate to WelcomeScreen
              logoutAndNavigateToWelcomeScreen(outerContext);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void logoutAndNavigateToWelcomeScreen(BuildContext profileContext) async {
    setState(() {
      loader = true;
    });
    // try {
    //   var response = await logoutUser();
    //   if (response?.status == true) {
    //     await appStore.clearData();
    //     isTokenAvailable(context);
    //   } else {
    //     if (response?.message != null) {
    //       SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
    //           response?.message ?? errorSomethingWentWrong);
    //     }
    //   }
    // } catch (e) {
    //   debugPrint('logoutUser Error: $e');
    // } finally {
    //   setState(() {
    //     loader = false;
    //   });
    // }
    await appStore.clearData();
    isTokenAvailable(context);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () {
          var now = DateTime.now();

          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            toast('Please click BACK again to exit');
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.grey,
                height: 0.5,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Image.asset(
                'assets/images/ic_icon.png',
              ),
            ),
            centerTitle: true,
            title: Text(
              [
                'Welcome',
                'Session',
                appStore.userTypeCoach ? 'Add Slot' : 'Available Coaches',
                'Profile',
              ][currentIndex],
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.8),
                  fontSize: 20),
            ),
            actions: [
              Stack(
                children: [
                  const Icon(Icons.notifications),
                  // Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 6,
                  //     height: 6,
                  //     decoration: boxDecorationDefault(color: redColor),
                  //   ),
                  // ),
                ],
              ).onTap(() async {
                var res = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationPage()));
                if (res) {
                  switchToFragment(1);
                }
              }),
              if (currentIndex == 3 ||
                  (appStore.additionalSponsor.isNotEmpty && currentIndex == 1))
                Text(
                  'Logout',
                  style: TextStyle(color: primaryColor),
                ).onTap(() {
                  showLogoutConfirmationDialog(context);
                }).paddingLeft(10),
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WebViewScreen(
                                    url: aboutUsUrl,
                                  )));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.business),
                        SizedBox(
                          width: 10,
                        ),
                        Text('About Us')
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WebViewScreen(
                                    url: contactUsUrl,
                                  )));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.contact_mail_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Contact Us')
                      ],
                    ),
                  ),
                  // PopupMenuItem(
                  //   value: 3,
                  //   onTap: () {
                  //     showRatingDialog(context);
                  //   },
                  //   child: const Row(
                  //     children: [
                  //       Icon(Icons.star),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text('Feedback')
                  //     ],
                  //   ),
                  // ),
                ],
                offset: const Offset(0, 50),
                elevation: 2,
              ),
            ],
          ),
          body: PageStorage(
            key: PageStorageKey<String>('page$currentIndex'),
            bucket: PageStorageBucket(),
            child: fragmentList[currentIndex],
          ),
          bottomNavigationBar: Blur(
            blur: 30,
            borderRadius: radius(0),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: context.primaryColor.withOpacity(0.02),
                indicatorColor: context.primaryColor.withOpacity(0.1),
                labelTextStyle:
                    WidgetStateProperty.all(primaryTextStyle(size: 12)),
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: NavigationBar(
                selectedIndex: currentIndex,
                destinations: [
                  NavigationDestination(
                    icon: icHome.iconImage(color: textColor),
                    selectedIcon:
                        icHomeFilled.iconImage(color: context.primaryColor),
                    label: 'Home',
                  ),
                  if (appStore.additionalSponsor.isEmpty)
                    NavigationDestination(
                      icon: icSession.iconImage(color: textColor),
                      selectedIcon: icSessionFilled.iconImage(
                          color: context.primaryColor),
                      label: 'Session',
                    ),
                  if (appStore.additionalSponsor.isEmpty)
                    NavigationDestination(
                      icon: icFeedback.iconImage(color: textColor),
                      selectedIcon: icFeedbackFilled.iconImage(
                          color: context.primaryColor),
                      label: appStore.userTypeCoach ? 'Slots' : 'Coaches',
                    ),
                  NavigationDestination(
                    icon: icUser.iconImage(color: textColor),
                    selectedIcon:
                        icUserFilled.iconImage(color: context.primaryColor),
                    label: 'Profile',
                  ),
                ],
                onDestinationSelected: (index) {
                  if (appStore.additionalSponsor.isNotEmpty) {
                    if (index == 0) {
                      switchToFragment(0); // go to home
                    } else {
                      switchToFragment(1); // go to profile
                    }
                  } else {
                    switchToFragment(index);
                  }
                },
              ),
            ),
          ),
        ),
      );
}

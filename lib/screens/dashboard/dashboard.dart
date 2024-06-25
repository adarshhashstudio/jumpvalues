import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_dashbaord.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_add_slots.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_dashbaord.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_sessions.dart';
import 'package:jumpvalues/screens/utils/common.dart';
import 'package:jumpvalues/screens/utils/images.dart';
import 'package:jumpvalues/screens/utils/string_extensions.dart';
import 'package:jumpvalues/screens/utils/utils.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';
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
      appStore.userTypeCoach ? const CoachSessions() : Container(),
      appStore.userTypeCoach ? const CoachAddSlots() : Container(),
      Container(),
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
                appStore.userTypeCoach ? 'Add Slot' : 'Feedback',
                'Profile',
              ][currentIndex],
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.8),
                  fontSize: 20),
            ),
            actions: [
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
                  NavigationDestination(
                    icon: icSession.iconImage(color: textColor),
                    selectedIcon:
                        icSessionFilled.iconImage(color: context.primaryColor),
                    label: 'Session',
                  ),
                  NavigationDestination(
                    icon: icFeedback.iconImage(color: textColor),
                    selectedIcon:
                        icFeedbackFilled.iconImage(color: context.primaryColor),
                    label: appStore.userTypeCoach ? 'Slots' : 'Feedback',
                  ),
                  NavigationDestination(
                    icon: icUser.iconImage(color: textColor),
                    selectedIcon:
                        icUserFilled.iconImage(color: context.primaryColor),
                    label: 'Profile',
                  ),
                ],
                onDestinationSelected: switchToFragment,
              ),
            ),
          ),
        ),
      );
}

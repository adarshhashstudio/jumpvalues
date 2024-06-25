import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_add_slots.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_dashbaord.dart';
import 'package:jumpvalues/screens/dashboard/client_fragments/client_sessions.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_add_slots.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_dashbaord.dart';
import 'package:jumpvalues/screens/dashboard/coach_fragments/coach_sessions.dart';
import 'package:jumpvalues/screens/dashboard/common_profile.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
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
      appStore.userTypeCoach ? const CoachSessions() : const ClientSessions(),
      appStore.userTypeCoach ? const CoachAddSlots() : const ClientAddSlots(),
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
    try {
      var response = await logoutUser();
      if (response?.statusCode == 200) {
        setState(() {
          loader = false;
        });

        await appStore.clearData();

        // // Navigate to WelcomeScreen
        await Navigator.of(profileContext).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (Route<dynamic> route) => false);
      } else if (response?.statusCode == 403) {
        setState(() {
          loader = false;
        });

        await appStore.clearData();

        isTokenAvailable(context);
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      rethrow;
    }
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
                'Add Slot',
                'Profile',
              ][currentIndex],
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.8),
                  fontSize: 20),
            ),
            actions: [
              if (currentIndex == 3)
                Text(
                  'Logout',
                  style: TextStyle(color: primaryColor),
                ).onTap(() {
                  showLogoutConfirmationDialog(context);
                }),
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
                    label: 'Slots',
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

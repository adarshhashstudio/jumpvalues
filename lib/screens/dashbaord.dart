import 'package:flutter/material.dart';
import 'package:jumpvalues/common.dart';
import 'package:jumpvalues/screens/learn_screen.dart';
import 'package:jumpvalues/screens/profile_screen.dart';
import 'package:jumpvalues/screens/select_screen.dart';
import 'package:jumpvalues/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    isTokenAvailable(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'assets/images/blue_jump.png',
          ),
        ),
        centerTitle: true,
        title: Text(
          'Welcome',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
              fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_sharp),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                gradientContainer(context,
                    startColor: const Color(0xFFF69273),
                    endColor: const Color(0xFFFF6E7A),
                    icon: 'assets/images/learn.png',
                    title:
                        'Start your Journey by learning more about personal values.',
                    buttonTitle: 'Learn ( Values )', onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LearnScreen()));
                }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                gradientContainer(context,
                    startColor: const Color(0xFF95cfd3),
                    endColor: const Color(0xFF96d3c5),
                    icon: 'assets/images/select.png',
                    title:
                        'Click to select your values from our comprehensive list.',
                    buttonTitle: 'Select ( Values )', onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SelectScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gradientContainer(BuildContext context,
      {required Color startColor,
      required Color endColor,
      void Function()? onTap,
      required String icon,
      required String title,
      required String buttonTitle}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
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
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

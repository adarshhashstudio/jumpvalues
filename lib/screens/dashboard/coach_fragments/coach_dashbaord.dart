import 'package:flutter/material.dart';
import 'package:jumpvalues/screens/client_screens/select_screen.dart';
import 'package:jumpvalues/screens/utils/common.dart';
import 'package:jumpvalues/screens/utils/utils.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';

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
                    icon: learnImage,
                    title:
                        'Start your Journey by learning more about personal values.',
                    buttonTitle: 'Learn ( Values )', onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                            url: learnSectionUrl,
                          )));
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const LearnScreen()));
                }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                gradientContainer(context,
                    startColor: const Color(0xFF95cfd3),
                    endColor: const Color(0xFF96d3c5),
                    icon: selectImage,
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
      );

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

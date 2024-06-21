import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jumpvalues/screens/client_screens/select_screen.dart';
import 'package:jumpvalues/screens/utils/common.dart';
import 'package:jumpvalues/screens/utils/images.dart';
import 'package:jumpvalues/screens/utils/utils.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
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
                      width: MediaQuery.of(context).size.height * 0.02,
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
                )
              ],
            ),
          ),
        ),
      );
}

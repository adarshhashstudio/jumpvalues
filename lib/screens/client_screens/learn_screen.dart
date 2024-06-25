import 'package:flutter/material.dart';
import 'package:jumpvalues/utils/configs.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Learn (VALUES)',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.8),
                fontSize: 20),
          ),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ),
          ),
        ),
      );
}

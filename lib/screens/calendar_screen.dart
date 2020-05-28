import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/components/bottom_bar.dart';

class CalendarScreen extends StatelessWidget {
  static const String id = 'calendar_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kDarkBlueGrey, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Calendar',
          style: kHeaderTextStyle,
        ),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}

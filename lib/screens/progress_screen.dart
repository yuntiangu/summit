import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/components/bottom_bar.dart';

class ProgressScreen extends StatelessWidget {
  static const String id = 'progress_screen';

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
          'Progress',
          style: kHeaderTextStyle,
        ),
      ),
      bottomNavigationBar: BottomBar(2),
    );
  }
}

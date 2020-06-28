import 'package:flutter/material.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/constants.dart';

class RewardScreen extends StatelessWidget {
  static const String id = 'reward_screen';

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
          'Rewards',
          style: kHeaderTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'your icons:',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Image.asset('images/logoBlue.png'),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Image.asset('images/logoBlue.png'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Image.asset('images/logoBlue.png'),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Image.asset('images/logoBlue.png'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Image.asset('images/logoBlue.png'),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Image.asset('images/logoBlue.png'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(3),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:summit2/components/RoundedButton.dart';
import 'package:summit2/constants.dart';

import 'login_screen.dart';
import 'lumi_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kHomeBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('images/logoMystic.png'),
                ),
                SizedBox(
                  height: 30.0,
                ),
                RoundedButton(
                  colour: kLightBlueGrey,
                  textColour: kDarkBlueGrey,
                  title: 'Sign Up',
                  onPressed: () {
                    Navigator.pushNamed(context, SignupScreen.id);
                  },
                ),
                RoundedButton(
                  colour: kLightBlueGrey,
                  textColour: kDarkBlueGrey,
                  title: 'Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                RoundedButton(
                  colour: kLightBlueGrey,
                  textColour: kDarkBlueGrey,
                  title: 'Log In with LumiNUS',
                  onPressed: () {
                    Navigator.pushNamed(context, LumiScreen.id);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/todo_category_data.dart';
import 'package:summit2/screens/login_screen.dart';
import 'package:summit2/screens/signup_screen.dart';
import 'package:summit2/screens/todo/task_screen.dart';
import 'package:summit2/screens/todo/todo_home.dart';
import 'package:summit2/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //CategoryData
      create: (context) => CategoryData(),
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: kDarkBlueGrey,
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          TodoHome.id: (context) => TodoHome(),
          TaskScreen.id: (context) => TaskScreen(),
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/calendar/add_event.dart';
import 'package:summit2/models/calendar/calendar_event_data.dart';
import 'package:summit2/models/calendar/edit_event_screen.dart';
import 'package:summit2/models/category/todo_category_data.dart';
import 'package:summit2/screens/login_screen.dart';
import 'package:summit2/screens/lumi_screen.dart';
import 'package:summit2/screens/progress_screen.dart';
import 'package:summit2/screens/rewards_screen.dart';
import 'package:summit2/screens/signup_screen.dart';
import 'package:summit2/screens/todoScreens/todo_home.dart';
import 'package:summit2/screens/welcome_screen.dart';

import 'models/task/todo_task_data.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/rewards_screen.dart';

Future<void> main() async {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryData(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskData(),
        ),
        ChangeNotifierProvider(
          create: (context) => EventData(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: kDarkBlueGrey,
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          LumiScreen.id: (context) => LumiScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          TodoHome.id: (context) => TodoHome(),
          CalendarScreen.id: (context) => CalendarScreen(),
          ProgressScreen.id: (context) => ProgressScreen(),
          RewardScreen.id: (context) => RewardScreen(),
          AddEventPage.id: (context) => AddEventPage(),
          EditEventScreen.id: (context) => EditEventScreen(),
        },
      ),
    );
  }
}

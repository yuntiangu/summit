import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

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
        ),
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

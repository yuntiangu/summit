import 'package:flutter/material.dart';
import 'package:summit2/screens/todoScreens/todo_home.dart';

import 'screens/calendar/calendar_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/rewards_screen.dart';

const kHomeBackgroundColor = Color(0xff32465f);
const kDarkBlueGrey = Color(0xff2D3F54);
const kLightBlueGrey = Color(0xffDEE3EB);
const kPurple = Color(0xffB6B3EF);
const kYellow = Color(0xffFEE0AE);
const kPink = Color(0xffE8C8E6);
const kBlue = Color(0xffA6C8FE);
const kGrey = Color(0xffE8E8E8);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a Value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDarkBlueGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDarkBlueGrey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kHeaderTextStyle = TextStyle(
  color: kDarkBlueGrey,
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);

const kToDoHomeTextStyle = TextStyle(
  color: kDarkBlueGrey,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kEventTextStyle = TextStyle(
  color: kDarkBlueGrey,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

const kEventDateTextStyle = TextStyle(
  color: kDarkBlueGrey,
  fontSize: 14.0,
);

const kCalendarHeaderStyle = TextStyle(
  color: kDarkBlueGrey,
  fontWeight: FontWeight.bold,
);

const List<String> kListScreens = [
  TodoHome.id,
  CalendarScreen.id,
  ProgressScreen.id,
  RewardScreen.id,
];

import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const String id = 'calendar_screen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TableCalendar(
          calendarController: _calendarController,
          calendarStyle: CalendarStyle(
            contentPadding: EdgeInsets.all(20.0),
            todayStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: kDarkBlueGrey,
              decoration: TextDecoration.underline,
            ),
            todayColor: null,
            selectedColor: kDarkBlueGrey,
          ),
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            titleTextStyle: kHeaderTextStyle,
            formatButtonShowsNext: false,
          ),
          onDaySelected: (date, events) {
            print(date.toIso8601String());
          },
        ),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}

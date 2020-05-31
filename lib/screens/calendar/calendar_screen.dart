import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/models/calendar/calendar_event_data.dart';
import 'package:summit2/models/calendar/event_tile.dart';
import 'package:summit2/screens/calendar/add_calendar_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/models/calendar/event_list.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  static const String id = 'calendar_screen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events = EventData().events;
  DateTime _selectedDay;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.week,
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
                weekendStyle: null,
                outsideStyle: TextStyle(color: Colors.grey),
                outsideWeekendStyle: TextStyle(color: Colors.grey),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: kCalendarHeaderStyle,
                weekendStyle: kCalendarHeaderStyle,
              ),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                titleTextStyle: kHeaderTextStyle,
                formatButtonShowsNext: false,
              ),
              onDaySelected: (date, events) {
                setState(() {
                  _selectedDay = DateTime(date.year, date.month, date.day);
                  print(_selectedDay);
                });
              },
            ),
            Expanded(
              child: EventsList(_selectedDay),
            ),
          ],
        ),
      ),
      floatingActionButton: AddFab(
        screen: AddCalendarScreen(),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}

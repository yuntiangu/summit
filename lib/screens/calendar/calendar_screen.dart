import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/calendar/add_event.dart';
import 'package:summit2/models/calendar/event.dart';
import 'package:summit2/models/calendar/view_event.dart';
import 'package:table_calendar/table_calendar.dart';

FirebaseUser loggedInUser;
Firestore _firestore = Firestore.instance;

class CalendarScreen extends StatefulWidget {
  static const String id = 'calendar_screen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _controller;
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> _events;
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupData(AsyncSnapshot snapshot) {
    Map<DateTime, List<dynamic>> data = {};
    List<DocumentSnapshot> j = snapshot.data.documents;
    for (DocumentSnapshot ds in j) {
      if (ds['event_date'] != null) {
        Timestamp ts = ds['event_date'];
        DateTime dt =
            DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);
        String dsTitle = ds['title'];
        String dsDescription = ds['description'];
        EventModel toAdd = EventModel(
          title: dsTitle,
          description: dsDescription,
          eventDate: dt,
        );
        if (data[dt] == null) data[dt] = [];
        data[dt].add(toAdd);
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: StreamBuilder(
          stream: _firestore.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _events = _groupData(snapshot);
            } else {
              _events = {};
              _selectedEvents = [];
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TableCalendar(
                    events: _events,
                    initialCalendarFormat: CalendarFormat.week,
                    calendarStyle: CalendarStyle(
                        markersColor: kDarkBlueGrey,
                        canEventMarkersOverflow: true,
                        todayColor: Colors.orange,
                        selectedColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    onDaySelected: (date, events) {
                      setState(() {
                        _selectedEvents = events;
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    calendarController: _controller,
                  ),
                  ..._selectedEvents.map((event) => ListTile(
                        title: Text(event.title),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventDetailsPage(
                                        event: event,
                                      )));
                        },
                      )),
                ],
              ),
            );
          }),
      floatingActionButton: AddFab(
        screen: AddEventPage(),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}

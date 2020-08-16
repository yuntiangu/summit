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

Firestore _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class CalendarScreen extends StatefulWidget {
  static const String id = 'calendar_screen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _controller;
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> _events;
  String email;
  QuerySnapshot firstValue;
  bool gotData;
  DateTime _selectedDate;

  Future<String> getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  Future<CollectionReference> eventRef(String userEmail) async {
    FirebaseUser user = await _auth.currentUser();
    String userEmail = user.email;
    return _firestore
        .collection('user')
        .document(userEmail)
        .collection('events');
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    _selectedDate = DateTime.now();
    initialiseCalendar().then((_) => setState(() {}));
  }

  Future<void> initialiseCalendar() async {
    await getEmail().then((value) async {
      this.email = value;
      eventRef(this.email)
          .then((value) => value.getDocuments().then((value) async {
                List<DocumentSnapshot> k = value.documents;
                firstValue = value;
                Map<DateTime, List<dynamic>> data = {};
                _events = {};
                for (DocumentSnapshot ds in k) {
                  if (ds['event_date'] != null) {
                    Timestamp ts = ds['event_date'];
                    DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
                        ts.microsecondsSinceEpoch);
                    String dsTitle = ds['title'];
                    String dsDescription = ds['description'];
                    String inId = ds['id'];
                    EventModel toAdd = EventModel(
                      title: dsTitle,
                      description: dsDescription,
                      eventDate: dt,
                      id: inId,
                    );
                    if (data[dt] == null) data[dt] = [];
                    data[dt].add(toAdd);
                  }
                }
                _events = data;
              }));
    });
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
        print(dsTitle);
        String dsDescription = ds['description'];
        String inId = ds['id'];
        EventModel toAdd = EventModel(
          title: dsTitle,
          description: dsDescription,
          eventDate: dt,
          id: inId,
        );
        DateTime indexDate =
            DateTime(dt.year, dt.month, dt.day, 12, 0, 0, 0, 0);
        if (data[indexDate] == null) data[indexDate] = [];
        data[indexDate].add(toAdd);
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
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('user')
              .document(email)
              .collection('events')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            } else {
              _events = _groupData(snapshot);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TableCalendar(
                      events: _groupData(snapshot),
                      initialCalendarFormat: CalendarFormat.month,
                      initialSelectedDay: DateTime.now(),
                      calendarStyle: CalendarStyle(
                          markersColor: Colors.grey[350],
                          markersMaxAmount: 1,
                          todayColor: kPink,
                          selectedColor: Theme.of(context).primaryColor,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: kLightBlueGrey,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: kDarkBlueGrey),
                        formatButtonShowsNext: false,
                      ),
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      onDaySelected: (date, events) {
                        setState(() {
                          _selectedDate = date;
                          _selectedEvents = events;
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: kBlue,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: Colors.transparent,
                              shape: kTodayBorder,
                            ),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      calendarController: _controller,
                    ),
                    ..._selectedEvents.map((event) => ListTile(
                          title: Text(event.title),
                          onTap: () {
                            print(event.id);
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
            }
          }),
      floatingActionButton: AddFab(
        screen: AddEventPage(
          selectedDate: this._selectedDate,
        ),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}

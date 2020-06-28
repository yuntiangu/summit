import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summit2/models/calendar/edit_event_screen.dart';
import 'package:summit2/models/calendar/event.dart';
import 'package:summit2/screens/calendar/calendar_screen.dart';

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

final _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;

class _EventDetailsPageState extends State<EventDetailsPage> {
  Future<void> deleteEvent(EventModel eventToDelete) async {
    print('deleteEvent called');
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    await _firestore
        .collection('user')
        .document(email)
        .collection('events')
        .document(eventToDelete.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.event.title}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.event.title,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 10.0),
            Text(
              widget.event.description,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(widget.event.eventDate.toString()),
            Row(
              children: <Widget>[
                OutlineButton(
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          EditEventScreen(inEventModel: this.widget.event),
                    );
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      deleteEvent(widget.event).then((_) =>
                          Navigator.pushNamed(context, CalendarScreen.id));
                    });
                  },
                  elevation: 5.0,
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.red,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

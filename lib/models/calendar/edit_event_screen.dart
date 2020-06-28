import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/calendar/event.dart';
import 'package:summit2/screens/calendar/calendar_screen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
Firestore _firestore = Firestore.instance;

class EditEventScreen extends StatefulWidget {
  static const String id = 'editEvent_screen';

  EventModel currEvent;
  EditEventScreen({inEventModel}) {
    this.currEvent = inEventModel;
  }

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  bool processing;
  String email;

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  Future<String> getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  void editFirestoreEvent() async {
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    Firestore.instance
        .collection('user')
        .document(email)
        .collection('events')
        .document(widget.currEvent.id)
        .setData({
      "id": widget.currEvent.id,
      "title": _title.text,
      "description": _description.text,
      "event_date": _eventDate,
    }, merge: true);
  }

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
      text: widget.currEvent.title,
    );
    _description = TextEditingController(
      text: widget.currEvent.description,
    );
    _eventDate = widget.currEvent.eventDate;
    processing = false;
    getEmail().then((value) => this.email = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Event"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter title" : null,
                  style: kEventTextStyle,
                  decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter description" : null,
                  style: kEventTextStyle,
                  decoration: InputDecoration(
                      labelText: "description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Date (YYYY-MM-DD)"),
                subtitle: Text(
                    "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                onTap: () async {
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: _eventDate,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              setState(() {
                                editFirestoreEvent();
                              });
                              Navigator.pushNamed(context, CalendarScreen.id);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Save",
                            style: kEventTextStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}

import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/calendar/event.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
Firestore _firestore = Firestore.instance;

class AddEventPage extends StatefulWidget {
  static const id = 'addEventPageId';
  final EventModel note;
  DateTime selectedDate;

  AddEventPage({Key key, this.note, this.selectedDate}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
//  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextStyle style = kEventTextStyle;
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
  String email;
  DocumentReference docRef;

  Future<String> getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  Future<void> addFirestoreEvent() async {
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    DocumentReference docRef = await _firestore
        .collection('user')
        .document(email)
        .collection('events')
        .document();
    docRef.setData({
      "id": docRef.documentID,
      "title": _title.text,
      "description": _description.text,
      "event_date": _eventDate,
    });
  }

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
        text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    _eventDate = widget.selectedDate;
    processing = false;
    getEmail().then((value) => this.email = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? "Edit Event" : "Add event"),
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
                  style: style,
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
                  style: style,
                  decoration: InputDecoration(
                      labelText: "description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                  title: Text("Date"),
                  subtitle: Text(
                      "${widget.selectedDate.year} - ${widget.selectedDate.month} - ${widget.selectedDate.day}"),
//                onTap: () async {
//                  DateTime picked = await showDatePicker(
//                      context: context,
//                      initialDate: widget.selectedDate,
//                      firstDate: DateTime(_eventDate.year - 5),
//                      lastDate: DateTime(_eventDate.year + 5));
//                  if (picked != null) {
//                    setState(() {
//                      _eventDate = picked;
//                    });
//                  }
//                },//onTap
                  onTap: Platform.isIOS
                      ? () {
                          DateTime picked = widget.selectedDate;
                          DatePicker.showDatePicker(
                            context,
                            theme: DatePickerTheme(
                              containerHeight: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height /
                                  3,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2019, 1, 1),
                            onConfirm: (dateTime) {
                              setState(() {
                                _eventDate = dateTime;
                              });
                            },
                          );
                        }
                      : () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: widget.selectedDate,
                              firstDate: DateTime(_eventDate.year - 5),
                              lastDate: DateTime(_eventDate.year + 5));
                          if (picked != null) {
                            setState(() {
                              _eventDate = picked;
                            });
                          }
                        }),
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
                              if (widget.note != null) {
                              } else {
                                await addFirestoreEvent();
                              }
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Save",
                            style: style.copyWith(
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

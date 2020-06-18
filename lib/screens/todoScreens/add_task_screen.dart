import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summit2/components/RoundedButton.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/task/todo_task_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = Firestore.instance;

class AddTaskScreen extends StatefulWidget {
  String _title;
  AddTaskScreen(this._title);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  static String newTaskTitle;
  static DateTime newDueDateTime;
  static String dueDateTimeString;
  static DateTime newReminderDateTime;
  static String reminderDateTimeString;

  @override
  void initState() {
    newTaskTitle = null;
    newDueDateTime = null;
    dueDateTimeString = "Set Due Date and Time";
    newReminderDateTime = null;
    reminderDateTimeString = "Set Reminder Date and Time";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDarkBlueGrey,
                fontSize: 30.0,
              ),
            ),
            TextField(
              autocorrect: true,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    theme: DatePickerTheme(
                      containerHeight:
                          MediaQuery.of(context).copyWith().size.height / 3,
                    ),
                    showTitleActions: true,
                    minTime: DateTime(2019, 1, 1),
                    onConfirm: (dateTime) {
                      print('confirm $dateTime');
                      setState(() {
                        dueDateTimeString = '${DateFormat.MMMMd('en_US').add_jm().format(dateTime)}';
                      });
                      newDueDateTime = dateTime;
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.en,
                );
              },
              child: Container(
                child: Text(
                  " $dueDateTimeString",
                  style: TextStyle(
                    color: kDarkBlueGrey,
                  ),
                ),
              ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                  theme: DatePickerTheme(
                    containerHeight:
                    MediaQuery.of(context).copyWith().size.height / 3,
                  ),
                  showTitleActions: true,
                  minTime: DateTime(2019, 1, 1),
                  onConfirm: (dateTime) {
                    print('confirm $dateTime');
                    setState(() {
                      reminderDateTimeString = '${DateFormat.MMMMd('en_US').add_jm().format(dateTime)}';
                    });
                    newReminderDateTime = dateTime;
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.en,
                );
              },
              child: Container(
                child: Text(
                  " $reminderDateTimeString",
                  style: TextStyle(
                    color: kDarkBlueGrey,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: RoundedButton(
                colour: kDarkBlueGrey,
                textColour: kGrey,
                title: 'Add',
                onPressed: () {
                  Provider.of<TaskData>(context, listen: false)
                      .addTaskFirestore(widget._title, newTaskTitle, newDueDateTime, newReminderDateTime);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

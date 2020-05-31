import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/components/RoundedButton.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/calendar/calendar_event_data.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddCalendarScreen extends StatelessWidget {
  static String newEventTitle;
  static DateTime newDate;
  static DateTime newDateTime;

  @override
  Widget build(BuildContext context) {
    try {
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
                'Add Event',
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
                onChanged: (newEvent) {
                  newEventTitle = newEvent;
                },
                decoration: InputDecoration(
                  hintText: 'Event Name',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 50.0),
                child: RoundedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                          headerColor: kGrey,
                          backgroundColor: Colors.white,
                          itemStyle: TextStyle(
                              color: kDarkBlueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      onChanged: (date) {
                        newDate = DateTime(date.year, date.month, date.day);
                        newDateTime = date;
                      },
                      onConfirm: (date) {
                        newDate = DateTime(date.year, date.month, date.day);
                        newDateTime = date;
                      },
                    );
                  },
                  title: 'Date',
                  colour: kGrey,
                  textColour: kDarkBlueGrey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: RoundedButton(
                  colour: kDarkBlueGrey,
                  textColour: kGrey,
                  title: 'Add',
                  onPressed: () {
                    Provider.of<EventData>(context, listen: false).addEvent(
                      newEventTitle: newEventTitle,
                      date: newDate,
                      dateTime: newDateTime,
                    );
                    Navigator.pop(context);
                    newEventTitle = "";
                    newDate = null;
                    newDateTime = null;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e, s) {
      print(s);
    }
  }
}

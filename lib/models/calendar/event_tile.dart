import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summit2/constants.dart';

class EventTile extends StatelessWidget {
  final String eventTitle;
  final Function longPressCallBack;
  final DateTime dateTime;

  EventTile({
    this.eventTitle,
    this.longPressCallBack,
    this.dateTime
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onLongPress: longPressCallBack,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            eventTitle,
            style: kEventTextStyle,
          ),
        ),
        subtitle: Text(
          DateFormat.yMEd().add_Hm().format(dateTime),
          style: kEventDateTextStyle,
        ),
      ),
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: kGrey,
          )
        )
      ),
    );
  }
}

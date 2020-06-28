import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summit2/constants.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final DateTime dueDateTime;
  final DateTime reminderDateTime;
  final Function checkboxCallback;
  final Function longPressCallBack;

  TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.dueDateTime,
      this.reminderDateTime,
      this.checkboxCallback,
      this.longPressCallBack});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallBack,
      title: Text(
        taskTitle,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: dueDateTime == null && reminderDateTime == null
          ? null
          : reminderDateTime == null
              ? Text(
                  'Due: ${DateFormat.MMMMd('en_US').add_jm().format(dueDateTime)}')
              : dueDateTime == null
                  ? Text(
                      'Reminder: ${DateFormat.MMMMd('en_US').add_jm().format(reminderDateTime)}')
                  : Text(
                      'Due: ${DateFormat.MMMMd('en_US').add_jm().format(dueDateTime)} \nReminder: ${DateFormat.MMMMd('en_US').add_jm().format(reminderDateTime)}'),
      isThreeLine:
          (reminderDateTime == null && dueDateTime == null) ? false : true,
      trailing: Checkbox(
        activeColor: kDarkBlueGrey,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
    );
  }
}

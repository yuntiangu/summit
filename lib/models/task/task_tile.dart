import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final DateTime dueDateTime;
  final Function checkboxCallback;
  final Function longPressCallBack;

  TaskTile({this.isChecked, this.taskTitle, this.dueDateTime, this.checkboxCallback, this.longPressCallBack});

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
      subtitle: dueDateTime != null ? Text('Due: ${DateFormat.MMMMd('en_US').add_jm().format(dueDateTime)}') : null,
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
    );
  }
}






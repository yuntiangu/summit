import 'package:flutter/material.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/task/task_list.dart';

import 'add_task_screen.dart';

class TaskScreen extends StatelessWidget {
  String _title;
  TaskScreen(this._title);
  static const String id = 'todo_task_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kDarkBlueGrey, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          _title,
          style: kHeaderTextStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    )),
                child: TasksList(_title),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AddFab(screen: AddTaskScreen(_title)),
    );
  }
}

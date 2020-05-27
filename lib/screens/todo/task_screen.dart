import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/todo/task_list.dart';
import 'package:summit2/todo/todo_task_data.dart';

import 'add_task_screen.dart';

class TaskScreen extends StatelessWidget {
  static String id = 'todo_task_screen';

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
          'All',
          style: kHeaderTextStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${Provider.of<TaskData>(context).taskCount} Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  )),
              child: TasksList(),
            ),
          ),
        ],
      ),
      floatingActionButton: AddFab(screen: AddTaskScreen()),
    );
  }
}

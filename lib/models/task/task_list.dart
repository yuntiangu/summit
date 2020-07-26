import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/task/todo_task_data.dart';

import 'task_tile.dart';

class TasksList extends StatelessWidget {
  String _categoryName;
  TasksList(String _categoryName){
    this._categoryName = _categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        //print('task data: $taskData');
        return (taskData.numberTasksCategory(_categoryName) == 0) ? Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 3,),
              Text(
                'No Tasks Yet',
                style: kProgressBarTextStyle,
              ),
            ],
          ),
        ) : Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final task = taskData.tasks[index];
              if (task.categoryName != _categoryName) {
                return SizedBox(height: 0.0,);
              }
              else if (task.name == null) {
                return SizedBox(height: 0.0,);
              }
              return TaskTile(
                taskTitle: task.name,
                dueDateTime: task.dueDateTime,
                reminderDateTime: task.reminderDateTime,
                isChecked: task.isDone,
                checkboxCallback: (checkboxState) {
                  taskData.updateTask(task);
                },
                longPressCallBack: () {
                  taskData.deleteTask(task);
                },
              );
            },
            itemCount: taskData.taskCount,
          ),
        );
      },
    );
  }
}

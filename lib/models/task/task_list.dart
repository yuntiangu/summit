import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/models/task/todo_task_data.dart';

import 'task_tile.dart';

class TasksList extends StatelessWidget {
  String _categoryName;
  TasksList(this._categoryName);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
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
        );
      },
    );
  }
}

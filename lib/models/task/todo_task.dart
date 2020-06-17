import 'package:flutter/cupertino.dart';

class Task {
  final String taskID;
  final String categoryName;
  final String name;
  final DateTime dueDateTime;
  bool isDone;

  Task({
    @required this.taskID,
    @required this.categoryName,
    @required this.name,
    this.dueDateTime,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }
}
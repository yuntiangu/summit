import 'package:flutter/cupertino.dart';

class Task {
  final String categoryName;
  final String name;
  bool isDone;

  Task({
    @required this.categoryName,
    @required this.name,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'todo_task.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final databaseReference = Firestore.instance;
final _auth = FirebaseAuth.instance;

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  int count = 0;

  TaskData() {
    getTaskData(_tasks);
  }

  void getTaskData(List<Task> listTasks) async {
    List<Task> _tasks = [];
    FirebaseUser user = await _auth.currentUser();
    String email = user.email;
    databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .snapshots()
        .listen((event) {
      event.documentChanges.forEach((element) {
        var data = element.document.data;
        print(data);
        Task task = Task(
            taskID: count,
            categoryName: data['category title'],
            name: data['task title'],
            isDone: data['done']);
        listTasks.add(task);
        count++;
      });
    });
    notifyListeners();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTaskFirestore(String categoryTitle, String taskTitle) async {
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    final task =
        Task(taskID: count, categoryName: categoryTitle, name: taskTitle);
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document('task $count')
        .setData({
      "category title": categoryTitle,
      "task title": taskTitle,
      "done": false,
    });
    notifyListeners();
  }

  void updateTask(Task task) async {
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    task.toggleDone();
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document('task ${task.taskID}')
        .updateData({
      "done": true,
    });
    notifyListeners();
  }

  void deleteTask(Task task) async {
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    print(task.taskID);
    print(databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document('task ${task.taskID}')
        .get());
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document('task ${task.taskID}')
        .delete();
    _tasks.remove(task);
    notifyListeners();
  }
}

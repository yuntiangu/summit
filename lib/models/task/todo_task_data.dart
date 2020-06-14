import 'package:flutter/foundation.dart';
import 'todo_task.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final databaseReference = Firestore.instance;
final _auth = FirebaseAuth.instance;

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];

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
        if (element.type == DocumentChangeType.added) {
          var data = element.document.data;
          print(data);
          Task task = Task(categoryName: data['category title'], name: data['task title']);
          listTasks.add(task);
        }
      });
    });
    notifyListeners();
  }

  TaskData(){
    getTaskData(_tasks);
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
    final task = Task(categoryName: categoryTitle, name: taskTitle);
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .add({
      "category title": categoryTitle,
      "task title": taskTitle,
    });
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

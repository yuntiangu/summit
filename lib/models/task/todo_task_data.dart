import 'package:flutter/foundation.dart';
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
          //print(data);
          Task task = Task(
              taskID: data['id'],
              categoryName: data['category title'],
              name: data['task title'],
              dueDateTime: data['due date time'] == null ? null : data['due date time'].toDate(),
              reminderDateTime: data['reminder date time'] == null ? null : data['reminder date time'].toDate(),
              isDone: data['done']);
          listTasks.add(task);
        }
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

  void addTaskFirestore(String categoryTitle, String taskTitle, DateTime dueDateTime, DateTime reminderDateTime) async {
    print('$count');
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    DocumentReference docRef = await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document();
    docRef.setData({
      "id": docRef.documentID,
      "category title": categoryTitle,
      "task title": taskTitle,
      "due date time": dueDateTime == null ? null : Timestamp.fromDate(dueDateTime),
      "reminder date time": reminderDateTime == null ? null : Timestamp.fromDate(reminderDateTime),
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
        .document('${task.taskID}')
        .updateData({
      "done": task.isDone,
    });
    notifyListeners();
  }

  void deleteTask(Task task) async {
    print("delete");
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document('${task.taskID}')
        .delete();
    _tasks.remove(task);
    notifyListeners();
  }
}

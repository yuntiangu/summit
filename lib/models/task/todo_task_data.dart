import 'package:flutter/foundation.dart';
import 'todo_task.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final databaseReference = Firestore.instance;
final _auth = FirebaseAuth.instance;

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  List<String> categoryNames = [];
  int totalTaskCount = 0;
  int totalTaskCompleted = 0;

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
              dueDateTime: data['due date time'] == null
                  ? null
                  : data['due date time'].toDate(),
              reminderDateTime: data['reminder date time'] == null
                  ? null
                  : data['reminder date time'].toDate(),
              isDone: data['done']);
          listTasks.add(task);
        }
      });
    });
    notifyListeners();
    databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .snapshots()
        .listen((event) {
      event.documentChanges.forEach((element) {
        if (element.document.documentID == "total") {
          var data = element.document.data;
          totalTaskCount = data["task count"];
          totalTaskCompleted = data["task completed"];
        }
      });
    });
  }


  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTaskFirestore(String categoryTitle, String taskTitle, DateTime dueDateTime, DateTime reminderDateTime) async {
    totalTaskCount++;
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    DocumentReference todoDocRef = await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document();
    todoDocRef.setData({
      "id": todoDocRef.documentID,
      "category title": categoryTitle,
      "task title": taskTitle,
      "due date time": dueDateTime == null ? null : Timestamp.fromDate(dueDateTime),
      "reminder date time": reminderDateTime == null ? null : Timestamp.fromDate(reminderDateTime),
      "done": false,
    });
    notifyListeners();

    //total progress bar
    DocumentReference progressTotalDocRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .document('total');
    progressTotalDocRef.setData({
      "task count": totalTaskCount,
      "task completed": totalTaskCompleted,
    });

    //category progress bar
    DocumentReference progressCatDocRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .document(categoryTitle);
    if (categoryNames.contains(categoryTitle)) {
      progressCatDocRef.updateData({
        "task count": FieldValue.increment(1),
      });
    } else {
      categoryNames.add(categoryTitle);
      progressCatDocRef.setData({
        "task count": 1,
        "task completed": 0,
      });
    }
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

    //total progress bar
    if (task.isDone) {
      totalTaskCompleted++;
    } else {
      totalTaskCompleted--;
    }
    await databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .document('total')
        .setData({
      "task count": totalTaskCount,
      "task completed": totalTaskCompleted,
    });

    //category progress bar
    DocumentReference progressCatDocRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .document(task.categoryName);
    if (task.isDone) {
      progressCatDocRef.updateData({
        "task completed": FieldValue.increment(1),
      });
    } else {
      progressCatDocRef.updateData({
        "task completed": FieldValue.increment(-1),
      });
    }
  }

  void deleteTask(Task task) async {
    if (task.isDone) {
      totalTaskCompleted--;
    }
    totalTaskCount--;
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
    await databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .document('total')
        .setData({
      "task count": totalTaskCount,
      "task completed": totalTaskCompleted,
    });

    //category progress bar
    DocumentReference progressCatDocRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .document(task.categoryName);
    if (task.isDone) {
      progressCatDocRef.updateData({
        "task count": FieldValue.increment(-1),
        "task completed": FieldValue.increment(-1),
      });
    } else {
      progressCatDocRef.updateData({
        "task count": FieldValue.increment(-1),
      });
    }
  }
}

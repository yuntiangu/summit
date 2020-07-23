import 'dart:ffi';

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
  int totalTaskCount = 0;
  int totalTaskCompleted = 0;
  int rewardsCounter = 0;
  String progressBarTotalDocId;

  TaskData() {
    getTaskData(_tasks);
  }

  Future<void> getTaskData(List<Task> listTasks) async {
    listTasks.clear();
    print('get task');
    FirebaseUser user = await _auth.currentUser();
    String email = user.email;
    this.progressBarTotalDocId = user.uid;
    databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .snapshots()
        .listen((event) {
      event.documentChanges.forEach((category) {
        var data = category.document.data;
        data.forEach((key, value) {
          if (key != 'category title') {
            Task task = Task(
              categoryName: value['category title'],
              name: value['task title'],
              dueDateTime: value['due date time'] == null
                  ? null
                  : value['due date time'].toDate(),
              reminderDateTime: value['reminder date time'] == null
                  ? null
                  : value['reminder date time'].toDate(),
              isDone: value['done'],
            );
            List<String> allTaskNames = [];
            for (Task printTask in listTasks) {
              allTaskNames.add(printTask.name);
              print('name ${printTask.name}');
            }
            if (allTaskNames.contains(task.name) == false) {
              print('adding get: ${task.name}');
              allTaskNames.add(task.name);
              listTasks.add(task);
            }
            print('end: $listTasks');
          }
        });
      });
    });
    notifyListeners();

    //progress bar
    databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .snapshots()
        .listen((event) {
      event.documentChanges.forEach((element) {
        if (element.document.documentID == progressBarTotalDocId) {
          var data = element.document.data;
          totalTaskCount = data["task count"];
          totalTaskCompleted = data["task completed"];
        }
      });
    });

    //rewards
    databaseReference
        .collection('user')
        .document(email)
        .collection('rewards')
        .snapshots()
        .listen((event) {
      event.documentChanges.forEach((element) {
        if (element.document.documentID == "rewards completed") {
          var data = element.document.data;
          rewardsCounter = data["rewards counter"];
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

  Future<void> addTaskFirestore(String categoryTitle, String taskTitle,
      DateTime dueDateTime, DateTime reminderDateTime) async {
    totalTaskCount++;
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;

    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document(categoryTitle)
        .updateData({
      taskTitle: {
        "category title": categoryTitle,
        "task title": taskTitle,
        "due date time":
            dueDateTime == null ? null : Timestamp.fromDate(dueDateTime),
        "reminder date time": reminderDateTime == null
            ? null
            : Timestamp.fromDate(reminderDateTime),
        "done": false,
      },
    });
    notifyListeners();

    //total progress bar
    CollectionReference progressCollRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress');
    DocumentReference progressDocRef;
    progressDocRef = progressCollRef.document(progressBarTotalDocId);
    await progressDocRef.setData({
      "task count": totalTaskCount,
      "task completed": totalTaskCompleted,
    });

    //category progress bar
    DocumentReference progressCatDocRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress')
        .document(categoryTitle);
    await progressCatDocRef.get().then((docSnapshot) {
      print(docSnapshot.documentID);
      progressCatDocRef.updateData({
        "task count": FieldValue.increment(1),
      });
    });
  }

  void updateTask(Task task) async {
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    task.toggleDone();
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .document(task.categoryName)
        .updateData({
      task.name: {
        "category title": task.categoryName,
        "task title": task.name,
        "due date time": task.dueDateTime == null
            ? null
            : Timestamp.fromDate(task.dueDateTime),
        "reminder date time": task.reminderDateTime == null
            ? null
            : Timestamp.fromDate(task.reminderDateTime),
        "done": task.isDone,
      },
    });
    notifyListeners();

    //total progress bar
    if (task.isDone) {
      totalTaskCompleted++;
    } else {
      totalTaskCompleted--;
    }
    CollectionReference progressCollRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress');
    DocumentReference progressDocRef;
    progressDocRef = progressCollRef.document(progressBarTotalDocId);
    progressDocRef.setData({
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
    //rewards counter
    DocumentReference rewardsDocRef = databaseReference
        .collection('user')
        .document(email)
        .collection('rewards')
        .document('rewards completed');
    if (task.isDone) {
      rewardsCounter++;
      rewardsDocRef.setData({
        "rewards counter": rewardsCounter,
      });
    } else {
      rewardsCounter--;
      rewardsDocRef.setData({
        "rewards counter": rewardsCounter,
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
        .document(task.categoryName)
        .updateData({
      task.name: FieldValue.delete(),
    });
    _tasks.remove(task);
    notifyListeners();

    CollectionReference progressCollRef = databaseReference
        .collection('user')
        .document(email)
        .collection('progress');
    DocumentReference progressDocRef;
    progressDocRef = progressCollRef.document(progressBarTotalDocId);
    progressDocRef.setData({
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

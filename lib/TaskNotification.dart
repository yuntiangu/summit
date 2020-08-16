import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskNotification {
  static bool hasSent = false;

  Future<void> sendOutDueTaskNotifications() async {
    print(hasSent);
    if (!hasSent) {
      hasSent = true;
      final FirebaseUser user = await _auth.currentUser();
      final String email = user.email;
      final CollectionReference categoryCollection =
          _db.collection('user').document(email).collection('to do');
      retrieveTaskNotifyingTime(categoryCollection);
    }
  }

  Future<void> retrieveTaskNotifyingTime(CollectionReference colRef) async {
    colRef.snapshots().listen((event) {
      event.documentChanges.forEach((category) {
        Map<String, dynamic> data = category.document.data;
        data.forEach((String key, value) async {
          if (key != 'category title') {
            Timestamp ts = value['reminder date time'] as Timestamp;
            final DateTime reminderDateTime = ts.toDate();
            if (reminderDateTime.day == currentDate.day &&
                reminderDateTime.month == currentDate.month &&
                reminderDateTime.year == currentDate.year) {
              final String notifTitle = value['category title'] as String;
              final String notifBody = value['task title'] as String;
              print(reminderDateTime);
            }
          }
        });
      });
    });
  }

  Future<void> init() async {
    print('task notifier init');
    sendOutDueTaskNotifications();
  }
}

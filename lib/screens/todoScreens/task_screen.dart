import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/category/category_box.dart';
import 'package:summit2/models/category/category_list.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/models/task/task_list.dart';
import 'package:summit2/models/task/task_tile.dart';
import 'package:summit2/models/task/todo_task.dart';
import 'package:summit2/models/task/todo_task_data.dart';
import 'add_category_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_task_screen.dart';

final _auth = FirebaseAuth.instance;
final databaseReference = Firestore.instance;

class TaskScreen extends StatefulWidget {
  String _title;
  static const String id = 'todo_task_screen';

  TaskScreen(this._title);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String email;

  Future<String> getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  @override
  Future<void> initState() {
    TaskData();
    super.initState();
    getEmail().then((value) => this.email = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: kDarkBlueGrey, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget._title,
          style: kHeaderTextStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: databaseReference
                    .collection('user')
                    .document(this.email)
                    .collection('to do')
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  } else {
                    return TasksList(widget._title);
                  }
                }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: AddFab(
                screen: AddTaskScreen(widget._title),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'package:summit2/components/add_fab.dart';
//import 'package:summit2/constants.dart';
//import 'package:summit2/models/task/task_list.dart';
//
//import 'add_task_screen.dart';
//
//class TaskScreen extends StatelessWidget {
//  String _title;
//  TaskScreen(this._title);
//  static const String id = 'todo_task_screen';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        iconTheme: IconThemeData(
//          color: kDarkBlueGrey, //change your color here
//        ),
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//        title: Text(
//          _title,
//          style: kHeaderTextStyle,
//        ),
//      ),
//      body: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            child: Expanded(
//              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 20.0),
//                decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(20.0),
//                      topRight: Radius.circular(20.0),
//                    )),
//                child: TasksList(_title),
//              ),
//            ),
//          ),
//        ],
//      ),
//      floatingActionButton: AddFab(screen: AddTaskScreen(_title)),
//    );
//  }
//}

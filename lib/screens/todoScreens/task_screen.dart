import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/models/task/task_list.dart';
import 'package:summit2/models/task/todo_task_data.dart';
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
  int rewardsCounter = 0;
  bool showAlert = false;
  int imageName;
  String imageIdentifier;

  Future<String> getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  Future<dynamic> getRewardsCounter() async {
    DocumentReference rewardDocRef = databaseReference
        .collection('user')
        .document(email)
        .collection('rewards')
        .document('rewards completed');
    rewardDocRef.snapshots().listen((event) {
      setState(() {
        this.rewardsCounter = event.data['rewards counter'];
        if (rewardsCounter == 5) {
          this.showAlert = true;
          this.imageName = 1;
          this.imageIdentifier = 'first';
        } else if (rewardsCounter == 50) {
          this.showAlert = true;
          this.imageName = 2;
          this.imageIdentifier = 'second';
        } else if (rewardsCounter == 100) {
          this.showAlert = true;
          this.imageName = 3;
          this.imageIdentifier = 'third';
        } else if (rewardsCounter == 200) {
          this.showAlert = true;
          this.imageName = 4;
          this.imageIdentifier = 'fourth';
        } else if (rewardsCounter == 500) {
          this.showAlert = true;
          this.imageName = 5;
          this.imageIdentifier = 'fifth';
        }
      });
    });
    print('REWARDS $rewardsCounter');
  }

  @override
  Future<void> initState() {
    TaskData();
    super.initState();
    getEmail().then((value) {
      this.email = value;
      getRewardsCounter();
    });
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
            (showAlert)
                ? (TaskData().numberTasksCategory(widget._title) > 0)
                    ? AlertDialog(
                        title: Text(
                          'Congratulations!',
                          style: kProgressBarHeaderTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          children: <Widget>[
                            Text(
                              'Remember that your hard work and consistency will most certainly pay off!\n\nHere is a new app icon for a fresh twist!',
                              style: TextStyle(color: kDarkBlueGrey),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Image.asset(
                              'images/rewards$imageName.png',
                              width: 120.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          OutlineButton(
                            child: Text(
                              'Set',
                              style: TextStyle(
                                  color: kDarkBlueGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              try {
                                if (await FlutterDynamicIcon
                                    .supportsAlternateIcons) {
                                  await FlutterDynamicIcon.setAlternateIconName(
                                      imageIdentifier);
                                  print("App icon change successful");
                                  setState(() {
                                    this.showAlert = false;
                                  });
                                  return;
                                }
                              } on PlatformException {} catch (e) {}
                              print("Failed to change app icon");
                            },
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          OutlineButton(
                            child: Text(
                              'Later',
                              style: TextStyle(
                                  color: kDarkBlueGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              setState(() {
                                this.showAlert = false;
                              });
                            },
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 0,
                      )
                : SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
      floatingActionButton: AddFab(
        screen: AddTaskScreen(widget._title),
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }
}

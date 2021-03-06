import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/task/todo_task_data.dart';

final databaseReference = Firestore.instance;
final _auth = FirebaseAuth.instance;

class ProgressScreen extends StatefulWidget {
  static const String id = 'progress_screen';

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String email;

  Future<String> getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  @override
  void initState() {
    super.initState();
    getEmail().then((value) {
      this.email = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: kDarkBlueGrey, //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                'Progress',
                style: kHeaderTextStyle,
              ),
            ),
            bottomNavigationBar: BottomBar(2),
            body: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 25.0,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: databaseReference
                      .collection('user')
                      .document(this.email)
                      .collection('progress')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final allData = snapshot.data.documents;
                      List<Widget> progressBars = [
                        Text(
                          "Categories",
                          style: kProgressBarHeaderTextStyle,
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                      ];
                      Column storeTotal;
                      if (allData.length == 0) {
                        return Center(
                          child: Text(
                            'No Tasks Yet',
                            style: kProgressBarTextStyle,
                          ),
                        );
                      }
                      for (var data in allData) {
                        int taskCount = data["task count"] as int;
                        int taskCompleted = data["task completed"] as int;
                        double percentCompleted;
                        print(taskCount);
                        if (taskCount == 0) {
                          percentCompleted = 0.0;
                        } else {
                          percentCompleted = taskCompleted / taskCount;
                        }
                        if (data.documentID != taskData.progressBarTotalDocId) {
                          print('percent completed: $percentCompleted');
                          Column progressBar = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LinearPercentIndicator(
                                lineHeight: 25.0,
                                percent: percentCompleted,
                                trailing: Text(
                                  (percentCompleted < 0.1)
                                      ? '      ${(percentCompleted * 100).toInt().toString()} %'
                                      : (percentCompleted == 1)
                                          ? '  ${(percentCompleted * 100).toInt().toString()} %'
                                          : '    ${(percentCompleted * 100).toInt().toString()} %',
                                  style: kProgressBarPercentTextStyle,
                                ),
                                progressColor: kDarkBlueGrey,
                              ),
                              Text(
                                "${data.documentID}",
                                style: kProgressBarTextStyle,
                              ),
                            ],
                          );
                          progressBars.add(progressBar);
                          progressBars.add(SizedBox(
                            height: 15.0,
                          ));
                        } else {
                          storeTotal = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Total",
                                style: kProgressBarHeaderTextStyle,
                              ),
                              SizedBox(
                                height: 7.0,
                              ),
                              LinearPercentIndicator(
                                lineHeight: 25.0,
                                percent: percentCompleted,
                                trailing: Text(
                                  (percentCompleted < 0.1)
                                      ? '      ${(percentCompleted * 100).toInt().toString()} %'
                                      : (percentCompleted == 1)
                                          ? '  ${(percentCompleted * 100).toInt().toString()} %'
                                          : '    ${(percentCompleted * 100).toInt().toString()} %',
                                  style: kProgressBarPercentTextStyle,
                                ),
                                progressColor: kDarkBlueGrey,
                              ),
                            ],
                          );
                        }
                      }
                      progressBars.add(storeTotal);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: progressBars,
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  },
                )));
      },
    );
  }
}

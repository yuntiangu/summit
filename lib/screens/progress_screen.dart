import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<void> initState() {
    super.initState();
    getEmail().then((value) {
      this.email = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: databaseReference
                    .collection('user')
                    .document(this.email)
                    .collection('progress')
                    .snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final allData = snapshot.data.documents;
                    for (var data in allData) {
                      if (data.documentID == 'total') {
                        print('DEBUGGG ${data['task count']}');
                        int totalTaskCount = data["task count"];
                        int totalTaskCompleted = data["task completed"];
                        double totalPercentCompleted = totalTaskCompleted/totalTaskCount;
                        return LinearPercentIndicator(
                          lineHeight: 16.0,
                          percent: totalPercentCompleted,
                          leading: Text(
                            "Total:  ",
                            style: kProgressBarHeaderTextStyle,
                          ),
                          trailing: Text(
                            '  ${(totalPercentCompleted*100).toStringAsFixed(1)} %',
                            style: kProgressBarPercentTextStyle,
                          ),
                          progressColor: kDarkBlueGrey,
                        );
                      }
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}




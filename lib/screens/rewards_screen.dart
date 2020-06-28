import 'package:flutter/material.dart';
import 'package:summit2/components/RoundedButton.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final databaseReference = Firestore.instance;
final _auth = FirebaseAuth.instance;

class RewardScreen extends StatefulWidget {
  static const String id = 'reward_screen';

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  String email;
  int rewardsCounter = 0;

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
    await rewardDocRef.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        this.rewardsCounter = snapshot.data['rewards counter'];
      });
    });
  }

  @override
  void initState() {
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
        iconTheme: IconThemeData(
          color: kDarkBlueGrey, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Rewards',
          style: kHeaderTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'App Icons:',
                        style: TextStyle(
                          color: kDarkBlueGrey,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        '$rewardsCounter Tasks Completed',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: OutlineButton(
                        child: Image.asset(
                          'images/appIcon_black.png',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: 25.0,
                    ),
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: OutlineButton(
                        child: (rewardsCounter < 10)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.lock_open,
                                    size: 65.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '10 Tasks',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: kDarkBlueGrey,
                                    ),
                                  ),
                                ],
                              )
                            : Image.asset(
                                'images/basic_mountain1.png',
                              ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: OutlineButton(
                        child: (rewardsCounter < 50)
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.lock_open,
                              size: 65.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '50 Tasks',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: kDarkBlueGrey,
                              ),
                            ),
                          ],
                        )
                            : Image.asset(
                          'images/basic_mountain2.png',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: 25.0,
                    ),
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: OutlineButton(
                        child: (rewardsCounter < 100)
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.lock_open,
                              size: 65.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '100 Tasks',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: kDarkBlueGrey,
                              ),
                            ),
                          ],
                        )
                            : Image.asset(
                          'images/basic_mountain3.png',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: OutlineButton(
                        child: (rewardsCounter < 200)
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.lock_open,
                              size: 65.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '200 Tasks',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: kDarkBlueGrey,
                              ),
                            ),
                          ],
                        )
                            : Image.asset(
                          'images/basic_mountain4.png',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: 25.0,
                    ),
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: OutlineButton(
                        child: (rewardsCounter < 500)
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.lock_open,
                              size: 65.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '500 Tasks',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: kDarkBlueGrey,
                              ),
                            ),
                          ],
                        )
                            : Image.asset(
                          'images/basic_mountain5.png',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(3),
    );
  }
}

//Container(
//child: Text(
//'your icons:',
//style: TextStyle(fontSize: 15.0),
//),
//),
//Row(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: <Widget>[
//Expanded(
//child: Container(
//child: Image.asset('images/logoBlue.png'),
//),
//),
//Expanded(
//child: Container(
//child: Image.asset('images/logoBlue.png'),
//),
//)
//],
//),
//Row(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: <Widget>[
//Expanded(
//child: Container(
//child: Image.asset('images/logoBlue.png'),
//),
//),
//Expanded(
//child: Container(
//child: Image.asset('images/logoBlue.png'),
//),
//)
//],
//),
//Row(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: <Widget>[
//Expanded(
//child: Container(
//child: Image.asset('images/logoBlue.png'),
//),
//),
//Expanded(
//child: Container(
//child: Image.asset('images/logoBlue.png'),
//),
//)
//],
//),

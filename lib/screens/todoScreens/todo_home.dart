import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/category/category_list.dart';
import 'package:summit2/notification.dart';

import 'add_category_screen.dart';

final _auth = FirebaseAuth.instance;

class TodoHome extends StatefulWidget {
  static const String id = 'todo_home';

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  String email;

  Future<String> getEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  @override
  Future<void> initState() {
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
          'To Do',
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
                  .document(email)
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
                  return CategoryList();
                }
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: AddFab(
                screen: AddCategoryScreen(),
              ),
            ),
            NotificationManager(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }
}

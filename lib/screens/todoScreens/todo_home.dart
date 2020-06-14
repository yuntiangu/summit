import 'package:flutter/material.dart';
import 'package:summit2/components/add_fab.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/category/category_list.dart';
import 'package:summit2/components/bottom_bar.dart';
import 'add_category_screen.dart';

class TodoHome extends StatelessWidget {
  static const String id = 'todo_home';

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
            Expanded(child: CategoryList()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: AddFab(
                screen: AddCategoryScreen(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }
}

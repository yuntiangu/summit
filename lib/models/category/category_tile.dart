import 'dart:io';

import 'package:flutter/material.dart';
import 'package:summit2/screens/todoScreens/task_screen.dart';

class CategoryTile extends StatelessWidget {
  final String catTitle;
  final bool isChecked;
  final String catDescription;
  final Function longPressCallback;

  CategoryTile(this.catTitle, this.isChecked, this.catDescription,
      this.longPressCallback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.content_paste),
      onLongPress: longPressCallback,
      title: Text(
        catTitle,
        style: TextStyle(
            decoration: isChecked ? TextDecoration.lineThrough : null),
      ),
      //subtitle: Text(catDescription),
      trailing: Platform.isIOS
          ? Icon(Icons.arrow_forward_ios)
          : Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
                builder: (context) => TaskScreen(catTitle)));
      },
    );
  }
}

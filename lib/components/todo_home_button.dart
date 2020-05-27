import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/screens/todo/task_screen.dart';

class TodoHomeButton extends StatelessWidget {
  TodoHomeButton({this.icon, this.text, this.number, this.iconColour}) {
    this.icon = icon;
    this.text = text;
    this.number = number;
    this.iconColour = iconColour;
  }

  IconData icon;
  String text;
  int number;
  Color iconColour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: FlatButton(
        color: kGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 15.0, top: 15.0, bottom: 15.0),
                  child: Icon(
                    icon,
                    color: iconColour,
                    size: 40.0,
                  ),
                ),
                Text(
                  text,
                  style: kToDoHomeTextStyle,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$number',
                style: kToDoHomeTextStyle,
              ),
            )
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, TaskScreen.id);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/components/RoundedButton.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/category/todo_category_data.dart';

class AddCategoryScreen extends StatelessWidget {
  static String newCategoryTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDarkBlueGrey,
                fontSize: 30.0,
              ),
            ),
            TextField(
              autocorrect: true,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newCategoryTitle = newText;
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: RoundedButton(
                colour: kDarkBlueGrey,
                textColour: kGrey,
                title: 'Add',
                onPressed: () {
                  Provider.of<CategoryData>(context, listen: false)
                      .addCategory(newCategoryTitle);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

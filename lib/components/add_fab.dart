import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';

class AddFab extends StatelessWidget {
  var screen;

  AddFab({screen}) {
    this.screen = screen;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      child: Icon(
        Icons.add,
        color: kDarkBlueGrey,
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => screen,
        );
      },
    );
  }
}

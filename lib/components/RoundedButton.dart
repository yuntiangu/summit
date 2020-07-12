import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    this.title,
    this.colour,
    this.textColour,
    @required this.onPressed,
  });

  final Color colour;
  final String title;
  final Color textColour;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 250.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: textColour,
            ),
          ),
        ),
      ),
    );
  }
}
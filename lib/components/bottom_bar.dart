import 'package:flutter/material.dart';
import 'package:summit2/constants.dart';

class BottomBar extends StatelessWidget {
  int currentIndex;

  BottomBar(int currentIndex) {
    this.currentIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        unselectedItemColor: Colors.blueGrey[300],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('To Do List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text('Progress'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redeem),
            title: Text('Rewards'),
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: kDarkBlueGrey,
        onTap: (int index) {
          if (index != currentIndex) {
            Navigator.pushNamed(context, kListScreens[index]);
          }
        }
    );
  }
}
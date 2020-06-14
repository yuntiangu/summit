import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/models/category/category_tile.dart';
import 'package:summit2/models/category/todo_category_data.dart';
import 'package:summit2/screens/todoScreens/task_screen.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryData>(builder: (context, categoryData, child) {
      print('${categoryData.categories} better work now');
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final cat = categoryData.categories[index];
          return CategoryTile(
            cat.name,
            false,
            'Work Desc',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (context) => TaskScreen(cat.name)));
            },
          );
        },
        itemCount: categoryData.categoryCount,
      );
    });
  }
}

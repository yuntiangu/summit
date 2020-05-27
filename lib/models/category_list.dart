import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summit2/components/todo_home_button.dart';
import 'package:summit2/constants.dart';
import 'package:summit2/models/todo_category_data.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryData>(
      builder: (context, categoryData, child) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final category = categoryData.categories[index];
            return TodoHomeButton(
              icon: Icons.today,
              text: category,
              iconColour: kDarkBlueGrey,
              number: 3,
            );
          },
          itemCount: categoryData.categoryCount,
        );
      },
    );
  }
}

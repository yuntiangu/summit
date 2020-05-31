import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:summit2/models/category/category_box.dart';
import 'package:summit2/models/task/task_list.dart';

class CategoryData extends ChangeNotifier {
  List<CategoryBox> _categories = [];

  UnmodifiableListView<CategoryBox> get categories {
    return UnmodifiableListView(_categories);
  }

  int get categoryCount {
    return _categories.length;
  }

  void addCategory(String newCategory) {
    _categories.add(CategoryBox(newCategory, TasksList()));
    notifyListeners();
    print('addCat() called');
  }

  void deleteCategory(CategoryBox categoryBox) {
    _categories.remove(categoryBox);
    notifyListeners();
  }
}

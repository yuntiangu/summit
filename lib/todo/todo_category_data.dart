import 'package:flutter/foundation.dart';
import 'dart:collection';

class CategoryData extends ChangeNotifier {
  List<String> _categories = ['Test',];

  UnmodifiableListView<String> get categories {
    return UnmodifiableListView(_categories);
  }

  int get categoryCount {
    return _categories.length;
  }

  void addCategory(String newCategory) {
    _categories.add(newCategory);
    notifyListeners();
  }

  void deleteTask(String category) {
    _categories.remove(category);
    notifyListeners();
  }
}
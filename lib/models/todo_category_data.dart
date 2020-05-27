import 'dart:collection';

import 'package:flutter/foundation.dart';

class CategoryData extends ChangeNotifier {
  List<String> _categories = [
    'Test',
  ];

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

  void deleteCategory(String category) {
    _categories.remove(category);
    notifyListeners();
  }
}

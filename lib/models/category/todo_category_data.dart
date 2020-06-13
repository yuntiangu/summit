import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:summit2/models/category/category_box.dart';
import 'package:summit2/models/task/task_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final databaseReference = Firestore.instance;
final _auth = FirebaseAuth.instance;

void getCategoryData(List<CategoryBox> listCategories) async {
  List<CategoryBox> _categories = [];
  List<String> _categoryNames = [];
  FirebaseUser user = await _auth.currentUser();
  String email = user.email;
  databaseReference
      .collection('user')
      .document(email)
      .collection('to do')
      .snapshots()
      .listen((event) {
    event.documentChanges.forEach((element) {
      if (element.type == DocumentChangeType.added) {
        var data = element.document.data;
        print(data);
        String categoryName = data['category title'];
        if (!_categoryNames.contains(categoryName)) {
          _categoryNames.add(categoryName);
          CategoryBox category = CategoryBox(categoryName, TasksList(categoryName));
          listCategories.add(category);
        }
      }
    });
  });
}

class CategoryData extends ChangeNotifier {
  List<CategoryBox> _categories = [];
  CategoryData(){
    getCategoryData(_categories);
  }

  UnmodifiableListView<CategoryBox> get categories {
    return UnmodifiableListView(_categories);
  }

  int get categoryCount {
    return _categories.length;
  }

  void addCategory(String newCategory) {
    _categories.add(CategoryBox(newCategory, TasksList(newCategory)));
    notifyListeners();
    print('addCat() called');
  }

  void deleteCategory(CategoryBox categoryBox) {
    _categories.remove(categoryBox);
    notifyListeners();
  }
}

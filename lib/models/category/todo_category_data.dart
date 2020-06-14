import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:summit2/models/category/category_box.dart';
import 'package:summit2/models/task/task_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final databaseReference = Firestore.instance;

class CategoryData extends ChangeNotifier {
  List<CategoryBox> _categories = [];

  void getCategoryData(List<CategoryBox> listCategories) async {
    print('debug');
    List<String> _categoryNames = [];
    FirebaseUser user = await _auth.currentUser();
    String email = user.email;
    print(email);
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .snapshots()
        .listen((event) {
      event.documents.forEach((element) {
        print(element);
        var data = element.data;
        print(data);
        String categoryName = data['category title'];
        if (!_categoryNames.contains(categoryName)) {
          _categoryNames.add(categoryName);
          CategoryBox category =
          CategoryBox(categoryName, TasksList(categoryName));
          listCategories.add(category);
          print(listCategories);
        }
      });
    });
    notifyListeners();
    print('$listCategories done');
  }

  CategoryData() {
    getCategoryData(_categories);
  }

  UnmodifiableListView<CategoryBox> get categories {
    return UnmodifiableListView(_categories);
  }

  int get categoryCount {
    return _categories.length;
  }

  void addCategory(String newCategory) async {
    final FirebaseUser user = await _auth.currentUser();
    final email = user.email;
    await databaseReference
        .collection('user')
        .document(email)
        .collection('to do')
        .add({
      "category title": newCategory,
      "task title": null,
    });
    notifyListeners();
  }

  void deleteCategory(CategoryBox categoryBox) {
    _categories.remove(categoryBox);
    notifyListeners();
  }
}

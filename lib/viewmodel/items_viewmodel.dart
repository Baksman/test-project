import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:project/datasources/source_response/error.dart';
import 'package:project/models/item.dart';
import 'package:project/repository/repository.dart';

class ItemViewmodel extends ChangeNotifier {
  final Repository repository;

  List<Item> _allItems;

  List<Item> _searchItems = [];

  List<Item> get searchItem => _searchItems;

  ItemViewmodel(this.repository);

  Future<Either<AppError, List<Item>>> getItem() async {
    final result = await repository.getItem();
    _searchItems = _allItems;
    // if it has items
    if (result.isRight())
      _allItems = result.fold((l) => l, (r) => r) as List<Item>;
    // notifyListeners();
    return result;
  }

  searchItems(String searchString) {
    if (searchString.isEmpty) {
      _searchItems = _allItems;
      notifyListeners();
      return;
    }

    print(_searchItems.length);
    // all items from local db
    _searchItems = _allItems.where((element) {
      return element.title.contains(searchString);
    }).toList();
    notifyListeners();
    // return _searchItems;
  }
}

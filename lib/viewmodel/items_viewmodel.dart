import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project/datasources/failure/error.dart';
import 'package:project/models/item.dart';
import 'package:project/repository/repository.dart';

class ItemViewmodel extends ChangeNotifier {
  final Repository repository;
  // if repository returns right(has item)
  bool _hasItem = false;

  bool get hasItem => _hasItem;

  ItemViewmodel(this.repository);

  Future<Either<AppError, List<Item>>> getItem() async {
    final result = await repository.getItem();

    _hasItem = result.isRight();
    notifyListeners();
    return result;
  }
}

import 'package:dartz/dartz.dart';
import 'package:project/datasources/failure/failure.dart';
// import 'package:project/failure/failure.dart';
import 'package:project/models/item.dart';
import 'package:localstorage/localstorage.dart';

abstract class LocalService {
  Future<void> saveItem(List<dynamic> items);
  Future<Either<Failure, List<Item>>> getItems();
  Future<bool> dataSource();
}

class LocalServiceImpl implements LocalService {
  final LocalStorage storage;
  LocalServiceImpl(this.storage);
  Future<void> saveItem(List<dynamic> item) async {
    // must be in json
    storage.setItem('item', item);
  }

  Future<Either<Failure, List<Item>>> getItems() async {
    List<Item> items = [];
    try {
      final itemsMap = storage.getItem("item");
      itemsMap.map((e) => items.add(Item.fromJson(e))).toList();
      return Right(items);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<bool> dataSource() async {
    final itemsMap = storage.getItem("item");

    return itemsMap == null;
  }
}

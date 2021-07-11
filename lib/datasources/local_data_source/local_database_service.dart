import 'package:dartz/dartz.dart';

import 'package:project/datasources/source_response/failure.dart';
// import 'package:project/failure/failure.dart';
import 'package:project/models/item.dart';
import 'package:localstorage/localstorage.dart';

enum dataSources { internet, local }

abstract class LocalService {
  Future<void> saveItem(List<dynamic> items);
  Future<Either<Failure, List<Item>>> getItems();
  Future<dataSources> dataSource();
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
      final itemsMap = await storage.getItem("item");
      itemsMap.map((e) => items.add(Item.fromJson(e))).toList();
      return Right(items);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<dataSources> dataSource() async {
    final itemsMap = await storage.getItem("item");

    return itemsMap == null ? dataSources.internet : dataSources.local;
  }
}

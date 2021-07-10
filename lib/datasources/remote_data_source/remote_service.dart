import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/datasources/failure/failure.dart';
import 'package:project/datasources/local_data_source/local_database_service.dart';
// import 'package:project/failure/failure.dart';
import 'package:project/models/item.dart';

abstract class RemoteService {
  Future<Either<Failure, List<Item>>> getItem();
}

class RemoteServiceImpl implements RemoteService {
  final LocalService localService;
  RemoteServiceImpl(this.localService);
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

// using either monad to for better error handling
// returns right if success , left when failure
  Future<Either<Failure, List<Item>>> getItem() async {
    final url = baseUrl + "/posts";
    try {
      List<Item> items = [];
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        localService.saveItem(response.data);
        response.data
            .map((rawItem) => items.add(Item.fromJson(rawItem)))
            .toList();
        return Right(items);
      }
      return Left(Failure(response.statusMessage));
    } on SocketException {
      return Left(Failure("Internet connection error"));
    } on HttpException {
      return Left(Failure("Couldn't fetch data from internet"));
    }
  }
}

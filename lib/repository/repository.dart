// repository decides where to get data from
import 'package:dartz/dartz.dart';
import 'package:project/datasources/failure/error.dart';
// import 'package:project/datasources/failure/failure.dart';
import 'package:project/datasources/local_data_source/local_database_service.dart';
import 'package:project/datasources/remote_data_source/remote_service.dart';
import 'package:project/models/item.dart';

class Repository {
  final LocalService localDataSource;
  final RemoteService remoteService;

  Repository({this.localDataSource, this.remoteService});
  Future<Either<AppError, List<Item>>> getItem() async {
    
    dataSources isInternetSource = await localDataSource.dataSource();

    if (isInternetSource == dataSources.internet) {
      final items = await remoteService.getItem();
      return items.fold((l) => Left(AppError(l.message)), (r) => Right([...r]));
    } else {
      final items = await localDataSource.getItems();

      return items.fold((l) => Left(AppError(l.message)), (r) => Right([...r]));
    }
  }
}

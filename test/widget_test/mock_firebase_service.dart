import 'package:dartz/dartz.dart';
import 'package:project/datasources/remote_data_source/firebase_service.dart';
import 'package:project/models/task.dart';
import 'package:project/datasources/source_response/success.dart';
import 'package:project/datasources/source_response/failure.dart';

class MockFirebaseService implements FirebaseService {
  @override
  Future<Either<Failure, Success>> addTask(TaskModel task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> completeTask(String taskid) {
    // TODO: implement completeTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> deleteTask(String taskId) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Either<Failure, Stream<List<TaskModel>>> getAllTask() {
    // TODO: implement getAllTask
    throw UnimplementedError();
  }

  @override
  Either<Failure, Stream<List<TaskModel>>> getCompletedTask() {
    // TODO: implement getCompletedTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> unCompleteTask(String taskid) {
    // TODO: implement unCompleteTask
    throw UnimplementedError();
  }

}

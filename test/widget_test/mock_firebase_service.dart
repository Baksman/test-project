import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:project/datasources/remote_data_source/firebase_service.dart';
import 'package:project/models/task.dart';
import 'package:project/datasources/source_response/success.dart';
import 'package:project/datasources/source_response/failure.dart';
final firestore = FakeFirebaseFirestore();
class FirebaseMock extends Mock implements FirebaseServiceImpl{

  final FakeFirebaseFirestore firebase;

  FirebaseMock(this.firebase);

  Future<Either<Failure, Success>> addTask(TaskModel task) async {
    try {
      await firebase.collection("tasks").doc(task.id).set(task.toMap());
      return Right(Success());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
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

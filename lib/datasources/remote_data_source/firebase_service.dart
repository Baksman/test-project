import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:project/datasources/failure/failure.dart';
import 'package:project/datasources/failure/success.dart';
import 'package:project/models/task.dart';

abstract class FirebaseService {
  Future<Either<Failure, Success>> addTask(TaskModel task);

  Either<Failure, Stream<List<TaskModel>>> getAllTask();

  Either<Failure, Stream<List<TaskModel>>> getCompletedTask();

  Future<Either<Failure, Success>> completeTask(String taskid);

  Future<Either<Failure, Success>> unCompleteTask(String taskid);

  Future<Either<Failure, Success>> deleteTask(String taskId);
}

class FirebaseServiceImpl implements FirebaseService {
  final firebase = FirebaseFirestore.instance;
  @override
  Future<Either<Failure, Success>> completeTask(String taskid) async {
    try {
      await firebase
          .collection("tasks")
          .doc(taskid)
          .update({"completedAt": Timestamp.now()});
      return Right(null);
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<List<TaskModel>>> getAllTask() {
    try {
      Stream<QuerySnapshot> qs = firebase.collection("tasks").snapshots();
      return Right(qs.map((event) =>
          event.docs.map((e) => TaskModel.fromMap(e.data())).toList()));
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> addTask(TaskModel task) async {
    try {
      await firebase.collection("tasks").doc(task.id).set(task.toMap());
      return Right(Success());
    } catch (e, s) {
      print(e);
      print(s);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteTask(String taskId) async {
    try {
      await firebase.collection("tasks").doc(taskId).delete();
      return Right(Success());
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> unCompleteTask(String taskid) async {
    try {
      await firebase
          .collection("tasks")
          .doc(taskid)
          .update({"completedAt": null});
      return Right(Success());
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<List<TaskModel>>> getCompletedTask() {
    try {
      Stream<QuerySnapshot> qs = firebase.collection("tasks").snapshots();
      return Right(qs.map((event) => event.docs
          .map((e) => TaskModel.fromMap(e.data()))
          .toList()
          .where((element) => element.isTaskCompleted)
          .toList()));
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }
}

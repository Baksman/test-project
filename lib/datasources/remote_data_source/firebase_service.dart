import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:project/datasources/failure/failure.dart';
import 'package:project/models/task.dart';

abstract class FirebaseService {
  Future<Either<Failure, Null>> addTask(TaskModel task);

  Either<Failure, Stream<List<TaskModel>>> getAllTask();

  Future<Either<Failure, Null>> completeTask(String taskid);

  Future<Either<Failure, Null>> unCompleteTask(String taskid);

  Future<Either<Failure, Null>> deleteTask(String taskId);
}

class FirebaseServiceImpl implements FirebaseService {
  final firebase = FirebaseFirestore.instance;
  @override
  Future<Either<Failure, Null>> completeTask(String taskid) async {
    try {
      await firebase
          .collection("tasks")
          .doc(taskid)
          .update({"completedAt": Timestamp.now()});
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<List<TaskModel>>> getAllTask() {
    try {
      Stream<QuerySnapshot> qs = firebase.collection("tasks").snapshots();
      return Right(qs.map((event) => event.docs
          .map((e) => TaskModel.fromMap(event.docs.first.data()))
          .toList()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Null>> addTask(TaskModel task) async {
    try {
      await firebase.collection("tasks").doc(task.id).set(task.toMap());
      return null;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Null>> deleteTask(String taskId) async {
    try {
      await firebase.collection("tasks").doc(taskId).delete();
      return null;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Null>> unCompleteTask(String taskid) async {
    try {
      await firebase
          .collection("tasks")
          .doc(taskid)
          .update({"completedAt": null});
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

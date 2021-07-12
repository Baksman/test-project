import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project/datasources/remote_data_source/firebase_service.dart';
import 'package:project/datasources/source_response/error.dart';
import 'package:project/datasources/source_response/success.dart';
import 'package:project/models/task.dart';

abstract class TaskViewModelBaseClass extends ChangeNotifier {
  Future<Either<AppError, Success>> addTask(TaskModel task) ;
  Stream<Either<AppError, List<TaskModel>>> getAllTask() ;
  Stream<Either<AppError, List<TaskModel>>> getCompletedTask() ;
  Future<Either<AppError, Success>> deleteTask(String taskId) ;
  Future<Either<AppError, Success>> completeTask(String taskId) ;
  Future<Either<AppError, Success>> unCompleteTask(String taskId) ;
}



class TaskViewModel extends ChangeNotifier implements TaskViewModelBaseClass {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCompletetaskLoading = false;
  bool get isCompletetaskLoading => _isCompletetaskLoading;
  StreamController _allTaskController =
      StreamController<Either<AppError, List<TaskModel>>>.broadcast();
  // StreamController _completedTaskController =
  //     StreamController<Either<AppError, List<TaskModel>>>.broadcast();
  final FirebaseService firebaseService;

  TaskViewModel(this.firebaseService);
  Future<Either<AppError, Success>> addTask(TaskModel task) async {
    _setState(true);
    final result = await firebaseService.addTask(task);
    _setState(false);
    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  void close() {
    _allTaskController.close();
  }

  Stream<Either<AppError, List<TaskModel>>> getAllTask() {
    return firebaseService.getAllTask().fold((l) {
      _allTaskController.sink
          .add(Left<AppError, List<TaskModel>>(AppError(l.message)));
      return _allTaskController.stream;
    }, (r) {
      r.listen((event) {
        _allTaskController.sink.add(Right<AppError, List<TaskModel>>(event));
      });

      return _allTaskController.stream;
    });
  }

  Stream<Either<AppError, List<TaskModel>>> getCompletedTask() {
    return firebaseService.getCompletedTask().fold((l) {
      _allTaskController.sink
          .add(Left<AppError, List<TaskModel>>(AppError(l.message)));
      return _allTaskController.stream;
    }, (r) {
      r.listen((event) {
        _allTaskController.sink.add(Right<AppError, List<TaskModel>>(event));
      });
      return _allTaskController.stream;
    });
  }

  Future<Either<AppError, Success>> completeTask(String taskId) async {
    _isCompletetaskLoading = true;
    notifyListeners();
    final result = await firebaseService.completeTask(taskId);
    _isCompletetaskLoading = false;
    notifyListeners();

    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  Future<Either<AppError, Success>> unCompleteTask(String taskId) async {
    _isCompletetaskLoading = true;
    notifyListeners();
    final result = await firebaseService.unCompleteTask(taskId);
    _isCompletetaskLoading = false;
    notifyListeners();
    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  Future<Either<AppError, Success>> deleteTask(String taskId) async {
    _setState(true);
    final result = await firebaseService.deleteTask(taskId);
    _setState(false);

    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  _setState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}

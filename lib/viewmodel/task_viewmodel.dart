import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:project/datasources/failure/error.dart';
import 'package:project/datasources/remote_data_source/firebase_service.dart';
import 'package:project/models/task.dart';

class TaskViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCompletetaskLoading = false;
  bool get isCompletetaskLoading => _isCompletetaskLoading;

  final FirebaseService firebaseService;

  TaskViewModel(this.firebaseService);
  Future<Either<AppError, Null>> addTask(TaskModel task) async {
    _setState(true);
    final result = await firebaseService.addTask(task);
    _setState(false);
    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  Either<AppError, Stream<List<TaskModel>>> getAllTask() {
    return firebaseService
        .getAllTask()
        .fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  Future<Either<AppError, Null>> completeTask(String taskId) async {
    _isCompletetaskLoading = true;
    notifyListeners();
    final result = await firebaseService.completeTask(taskId);
    _isCompletetaskLoading = false;
    notifyListeners();
    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  Future<Either<AppError, Null>> unCompleteTask(String taskId) async {
    _isCompletetaskLoading = true;
    notifyListeners();
    final result = await firebaseService.unCompleteTask(taskId);
    _isCompletetaskLoading = false;
    notifyListeners();
    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  Future<Either<AppError, Null>> deleteTask(String taskId) async {
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
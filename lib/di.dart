import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:localstorage/localstorage.dart';
import 'package:project/datasources/remote_data_source/remote_service.dart';
import 'package:project/repository/repository.dart';
import 'datasources/local_data_source/local_database_service.dart';
import 'datasources/remote_data_source/firebase_service.dart';

final sl = GetIt.instance;

void setUp() {
  // external package
  LocalStorage storage = new LocalStorage('todo_app');
  final firebase = FirebaseFirestore.instance;
  sl.registerFactory<LocalStorage>(() => storage);
  sl.registerFactory<LocalService>(() => LocalServiceImpl(sl()));
  sl.registerFactory<FirebaseService>(() => FirebaseServiceImpl(firebase));
  sl.registerFactory<RemoteService>(() => RemoteServiceImpl(sl()));
  sl.registerFactory<Repository>(
      () => Repository(localDataSource: sl(), remoteService: sl()));
}

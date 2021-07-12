import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart' as fire;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project/datasources/source_response/error.dart';
import 'package:project/models/task.dart';
// import 'package:project/repository/repository.dart';
import 'package:project/ui/screens/task_screen.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:project/di.dart' as di;
import 'mock.dart';
import 'mock_firebase_service.dart';

class MockTaskViewModel extends Mock implements TaskViewModel {
  final MockFirebaseService firebaseService;
  StreamController _allTaskController =
      StreamController<Either<AppError, List<TaskModel>>>.broadcast();
  MockTaskViewModel(this.firebaseService);
  final tTaskModel = TaskModel(
      title: "New task",
      isCompleted: false,
      description: "Description for new task",
      id: "2773fbfbs");
  Stream<Either<AppError, List<TaskModel>>> getAllTask() {
    try {
      _allTaskController.sink
          .add(Right<AppError, List<TaskModel>>(<TaskModel>[tTaskModel]));
      // return _allTaskController.stream;

      return Stream.value(
          Right<AppError, List<TaskModel>>(<TaskModel>[tTaskModel]));
    } catch (e) {
      _allTaskController.sink
          .add(Left<AppError, List<TaskModel>>(AppError(e.toString())));
      return _allTaskController.stream;
    }
  }

  Stream<Either<AppError, List<TaskModel>>> getCompletedTask() {
    try {
      // return _allTaskController.stream;

      return Stream.value(
          Right<AppError, List<TaskModel>>(<TaskModel>[tTaskModel]));
    } catch (e) {
      _allTaskController.sink
          .add(Left<AppError, List<TaskModel>>(AppError(e.toString())));
      return _allTaskController.stream;
    }
  }

  // dispose() {
  //   _allTaskController.close();
  // }
}

void main() async {
  setupFirebaseMock();

  //  tester.binding.scheduleWarmUpFrame();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await fire.Firebase.initializeApp();
    di.setUp();
  });

  group("All Task screen", () {
    testWidgets('Should display proper app bar title',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(wrapper(
        child: const TasksPage(
          isAll: true,
        ),
      ));

      // Create the Finders.
      final appBar = find.byKey(Key("appbar"));
      final titleFinder = find.text('All tasks');
      final notFinder = find.text('Completed tasks');

      expect(titleFinder, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(notFinder, findsNothing);
    });

    testWidgets(
        'Should show a circular progress indicator then fetch data [ListView]',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(wrapper(
        child: const TasksPage(
          isAll: true,
        ),
      ));

      // Create the Finders.
      final titleFinder = find.text('All tasks');
      final notFinder = find.text('Completed Tasks');
      final progressIndicatorFinder = find.byKey(Key("progress"));
      final listviewFinder = find.byKey(Key("listv"));

      expect(titleFinder, findsOneWidget);
      expect(notFinder, findsNothing);
      expect(progressIndicatorFinder, findsOneWidget);
      await tester.pump(Duration.zero);
      expect(listviewFinder, findsOneWidget);
    });
  });

  group("Completed task screen", ()  {
    testWidgets('Should show correct app bar title in screen',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(wrapper(
        child: const TasksPage(
          isAll: false,
        ),
      ));

      // Create the Finders.
      final titleFinder = find.text('Completed tasks');
      final notFinder = find.text('All tasks');

      expect(titleFinder, findsOneWidget);
      expect(notFinder, findsNothing);
    });

    testWidgets(
        'Should show a circular progress indicator then fetch data [ListView]',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(wrapper(
        child: const TasksPage(
          isAll: false,
        ),
      ));

      // Create the Finders.
  
      final progressIndicatorFinder = find.byKey(Key("progress"));
      final listviewFinder = find.byKey(Key("listv"));
      
      expect(progressIndicatorFinder, findsOneWidget);
      await tester.pump(Duration.zero);
      expect(listviewFinder, findsOneWidget);
    });
  });
}

MockTaskViewModel mk = MockTaskViewModel(MockFirebaseService());

Widget wrapper({@required Widget child}) {
  mk.getAllTask();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<TaskViewModel>(create: (_) => mk),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

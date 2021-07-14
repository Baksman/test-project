import 'dart:async';
import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart' as fire;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project/datasources/source_response/error.dart';
import 'package:project/datasources/source_response/success.dart';
import 'package:project/models/task.dart';
// import 'package:project/repository/repository.dart';
import 'package:project/ui/screens/task_screen.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:project/di.dart' as di;
import 'mock.dart';
import 'mock_firebase_service.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

final mockObserver = MockNavigationObserver();

class MockTaskViewModel extends Mock implements TaskViewModel {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final FirebaseMock firebaseService;
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

  Future<Either<AppError, Success>> addTask(TaskModel task) async {
    _setState(true);
    final result = await firebaseService.addTask(tTaskModel);
    _setState(false);
    return result.fold((l) => Left(AppError(l.message)), (r) => Right(r));
  }

  _setState(bool isLoading) {
    _isLoading = isLoading;
    // notifyListeners();
  }
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
    setUp(() {});
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
    testWidgets(
        "Should navigate to add from all task screeen on tap of + icon ",
        (tester) async {
      await tester.pumpWidget(wrapper(
        child: const TasksPage(
          isAll: true,
        ),
      ));

      final addIcon = find.byKey(Key("addicon"));
      final addTaskAppBar = find.byKey(Key("add-task"));

      expect(addIcon, findsOneWidget);
      await tester.tap(addIcon);
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(addTaskAppBar, findsOneWidget);
    });
  });

  group("Completed task screen", () {
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

  testWidgets("Should navigate to add from all task screeen on tap of + icon ",
      (tester) async {
    await tester.pumpWidget(wrapper(
      child: const TasksPage(
        isAll: false,
      ),
    ));

    final addIcon = find.byKey(Key("addicon"));
    final addTaskAppBar = find.byKey(Key("add-task"));

    expect(addIcon, findsOneWidget);
    await tester.tap(addIcon);
    await tester.pumpAndSettle();
    verify(mockObserver.didPush(any, any));
    expect(addTaskAppBar, findsOneWidget);
  });
}

MockTaskViewModel mk = MockTaskViewModel(FirebaseMock(firestore));

Widget wrapper({@required Widget child}) {
  mk.getAllTask();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<TaskViewModel>(create: (_) => mk),
    ],
    child: MaterialApp(
      home: child,
      navigatorObservers: [mockObserver],
    ),
  );
}

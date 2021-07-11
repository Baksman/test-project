import 'package:firebase_core/firebase_core.dart' as fire;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/datasources/remote_data_source/firebase_service.dart';
import 'package:project/di.dart';
import 'package:project/repository/repository.dart';
import 'package:project/ui/screens/task_screen.dart';
import 'package:project/viewmodel/bottom_navbar.dart';
import 'package:project/viewmodel/items_viewmodel.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:project/di.dart' as di;
import 'mock.dart';

void main() async {
  setupFirebaseMock();
  //  tester.binding.scheduleWarmUpFrame();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await fire.Firebase.initializeApp();
    di.setUp();
  });

  testWidgets('Test all task screen', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(wrapper(
      child: const TasksPage(
        isAll: true,
      ),
    ));

    // Create the Finders.
    final titleFinder = find.text('All tasks');
    final notFinder = find.text('Completed Tasks');

    expect(titleFinder, findsOneWidget);
    expect(notFinder, findsNothing);
  });

  testWidgets('Test completed task screen', (WidgetTester tester) async {
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
}

Widget wrapper({@required Widget child}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BottomNavbarViewmodel()),
      ChangeNotifierProvider(
          create: (_) => TaskViewModel(sl.get<FirebaseService>())),
      ChangeNotifierProvider(
          create: (_) => ItemViewmodel(sl.get<Repository>())),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

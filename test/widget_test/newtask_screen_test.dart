import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project/ui/screens/add_taskscreen.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';

import 'mock_firebase_service.dart';
import 'tasks_screen_test.dart';

void main() async {
  group("add task screen", () {
    testWidgets("should add task to db", (WidgetTester tester) async {
      await tester.pumpWidget(wrapper(
          child: AddTaskPage(
        isNew: true,
      )));

      final firstTextInput = find.byKey(Key("input1"));
      final secondTextInput = find.byKey(Key("input2"));
      final submitButton = find.byKey(Key("submit"));
      // final progressIndicator = find.byKey(Key("progress"));

      expect(firstTextInput, findsOneWidget);
      expect(secondTextInput, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.enterText(firstTextInput, "This is the first title");
      await tester.enterText(secondTextInput, "This is the first description");

      await tester.tap(submitButton);

      await tester.pump(Duration(seconds: 1));

      // expect to find a snackbar!
    });
  });
}

MockTaskViewModel mk = MockTaskViewModel(FirebaseMock(firestore));
Widget wrapper({@required Widget child}) {

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<TaskViewModel>(create: (_) => mk),
    ],
    child: MaterialApp(
      home: ScaffoldMessenger(child: Scaffold(body: child)),
    ),
  );
}

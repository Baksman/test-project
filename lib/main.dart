import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/repository/repository.dart';
import 'package:project/ui/screens/home_screen.dart';
import 'package:project/viewmodel/bottom_navbar.dart';
import 'package:project/viewmodel/items_viewmodel.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';
import 'datasources/remote_data_source/firebase_service.dart';
import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ItemViewmodel(sl.get<Repository>())),
        ChangeNotifierProvider(create: (_) => BottomNavbarViewmodel()),
        ChangeNotifierProvider(
            create: (_) => TaskViewModel(sl.get<FirebaseServiceImpl>()))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavbarViewmodel>(context);
    List<Widget> children = [
      HomePage(),
      TasksPage(
        title: 'All Tasks',
        tasks: FirebaseManager.shared.tasks,
      ),
      TasksPage(
        title: 'Completed Tasks',
        tasks:
            FirebaseManager.shared.tasks.where((t) => t.isCompleted).toList(),
      )
    ];

    return Scaffold(
      body: children[navProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          navProvider.changeIndex(index);
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed Tasks',
          ),
        ],
      ),
    );
  }
}

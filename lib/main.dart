import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/repository/repository.dart';
import 'package:project/ui/screens/home_screen.dart';
import 'package:project/ui/screens/task_screen.dart';
import 'package:project/viewmodel/bottom_navbar.dart';
import 'package:project/viewmodel/items_viewmodel.dart';
import 'package:project/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';
import 'datasources/remote_data_source/firebase_service.dart';
import 'di.dart';

void main() async {
  setUp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavbarViewmodel()),
        ChangeNotifierProvider(
            create: (_) => TaskViewModel(FirebaseServiceImpl())),
        ChangeNotifierProvider(
            create: (_) => ItemViewmodel(sl.get<Repository>())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavbarViewmodel>(context);
    List<Widget> children = [
      HomePage(),
      TasksPage(
        isAll: true,
      ),
      TasksPage(
        isAll: false,
      )
    ];

    return Scaffold(
      body: children[navProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          navProvider.changeIndex(index);
        },
        currentIndex: navProvider.currentIndex,
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

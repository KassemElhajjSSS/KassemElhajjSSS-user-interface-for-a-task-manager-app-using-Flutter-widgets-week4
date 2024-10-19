import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/TaskManagerApp.dart';
import 'screens/Favorite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('tasksBox'); // Open a Hive box to store tasks
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 16.0),
          button: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
      ),
      themeMode: ThemeMode
          .system, // Switches between light and dark theme (change with the change of system theme change)
      debugShowCheckedModeBanner: false,
      home: TaskManagerApp(),
      routes: {
        '/home': (context) => TaskManagerApp(),
        '/favorite': (context) => Favorite(),
      },
    );
  }
}

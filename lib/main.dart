import 'package:flutter/material.dart';
import 'package:todolist/screen/main_screen.dart';
import 'package:todolist/db/firebase.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  readAllTodoFB();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todolist App',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: const MainScreen(),
    );
  }
}
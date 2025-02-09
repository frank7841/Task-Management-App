import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_management_app/screens/home_screen.dart';

import 'firebase_options.dart';
import 'models/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialise firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initialise hive and register adapters
  await Hive.initFlutter();
  //register adapter
  Hive.registerAdapter(TaskAdapter()); //Register task adapter
  await Hive.openBox<Task>('tasks'); //Open a hive box for tasks

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

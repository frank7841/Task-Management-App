import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/screens/auth_wrapper.dart';
import 'package:task_management_app/screens/edit_task_screen.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/screens/login_screen.dart';
import 'package:task_management_app/screens/register_screen.dart';

import 'firebase_options.dart';
import 'models/task.dart';

//TODO Authentication with email and password
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialise firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initialise hive and register adapters
  await Hive.initFlutter();
  //register adapter
  Hive.registerAdapter(TaskAdapter()); //Register task adapter
  final taskBox = await Hive.openBox<Task>('tasks'); //Open a hive box for tasks

  runApp( ProviderScope(
    overrides: [
      hiveBoxProvider.overrideWithValue(taskBox),
    ],
      child: const MyApp()));
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
      routes: {
        '/auth': (context) =>  AuthWrapper(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),

      },
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

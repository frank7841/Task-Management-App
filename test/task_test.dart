// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:task_management_app/models/task.dart';
//
// void main() {
//   //initialise hive for testing
//   setUp(() async {
//     await Hive.initFlutter();
//     Hive.registerAdapter(TaskAdapter());
//     await Hive.openBox<Task>('tasks');
//   });
//   //close hive after testing
//   tearDown(() async {
//     await Hive.close();
//   });
//
//   group('Task Model test', () {
//     test('Task has been created correctly ', () {
//       final task = Task(
//         id: '1',
//         title: 'Prepare for the exam',
//         description: 'Phyc, Bio, Chem',
//         isDone: false,
//       );
//       expect(task.id, '1');
//       expect(task.title, 'Task 1');
//       expect(task.description, 'Description 1');
//       expect(task.isDone, false);
//     });
//     test('Task have been saved and can be retrieved from hive to hive',
//         () async {
//       final task = Task(
//         id: '1',
//         title: 'Prepare for the exam',
//         description: 'Phyc, Bio, Chem',
//         isDone: false,
//       );
//       final taskBox = Hive.box<Task>('tasks');
//       await taskBox.put(task.id, task);
//
//       final savedTask = taskBox.get(task.id);
//       expect(savedTask, isNotNull);
//       expect(savedTask!.title, 'Prepare for the exam');
//     });
//     test('Task completion status can be updated', () async {
//       final task = Task(
//         id: '1',
//         title: 'Prepare for the exam',
//         description: 'Phyc, Bio, Chem',
//         isDone: false,
//       );
//       final taskBox = Hive.box<Task>('tasks');
//       await taskBox.put(task.id, task);
//       //Update the task completion status
//       final updatedTask = task.copyWith(
//         isDone: true,
//       );
//       await taskBox.put(updatedTask.id, updatedTask);
//
//       final savedTask = taskBox.get(updatedTask.id);
//       expect(savedTask, isNotNull);
//       expect(savedTask!.isDone, true);
//     });
//   });
// }

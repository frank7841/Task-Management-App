import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/services/firestore_service.dart';

import '../models/task.dart';

class TaskRepository {
  final logger = Logger();
  final Box<Task> _taskBox;
  final FirestoreService _firestoreService;

  TaskRepository(this._taskBox, this._firestoreService);

//   final Box<Task> _taskBox = Hive.box<Task>('tasks');//instance of hive box
// final FirestoreService _firestoreService = FirestoreService();//instance of firestore service

  Future<void> createTask(Task task) async {
    try {
      await _taskBox.put(task.id, task); //save locally
      await _firestoreService.addTask(task); //save to firebase
    } catch (e) {
      logger.e('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskBox.put(task.id, task); //update locally
      await _firestoreService.updateTask(task); //update in firebase
    } catch (e) {
      logger.e('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id); //delete locally
    await _firestoreService.deleteTask(id); //delete in firebase
  }

  //mark task as completed
  Future<void> completeTask(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      task.isDone = true; // update the task completion status
      await updateTask(task);
    }
  }

  List<Task> getTasks() {
    return _taskBox.values.toList();
  }

  Future<void> syncTasksFromFirestore() async {
    List<Task> tasks = await _firestoreService.fetchTasks();
    for (var task in tasks) {
      await _taskBox.put(task.id, task); //save to local hive box
    }
  }
}

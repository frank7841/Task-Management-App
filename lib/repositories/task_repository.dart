import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/services/firestore_service.dart';

import '../models/task.dart';

class TaskRepository {
  final logger = Logger();
  final Box<Task> _taskBox;
  final FirestoreService _firestoreService;
  final String userId;

  TaskRepository(this._taskBox, this._firestoreService, this.userId);

  Future<void> createTask(Task task, String userId) async {
    try {
      await _taskBox.put(task.id, task); //save locally
      await _firestoreService.addTask(userId, task); //save to firebase
    } catch (e) {
      logger.e('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskBox.put(task.id, task); //update locally
      await _firestoreService.updateTask(userId, task); //update in firebase
    } catch (e) {
      logger.e('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id); //delete locally
    await _firestoreService.deleteTask(userId, id); //delete in firebase
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
    List<Task> tasks = await _firestoreService.fetchTasks(userId);
    for (var task in tasks) {
      await _taskBox.put(task.id, task); //save to local hive box
    }
  }
}

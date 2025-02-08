import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskRepository{
final Box<Task> _taskBox = Hive.box<Task>('tasks');

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  List<Task> getTasks() {
    return _taskBox.values.toList();
  }
}
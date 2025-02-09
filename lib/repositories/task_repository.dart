import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskRepository{
final Box<Task> _taskBox = Hive.box<Task>('tasks');

  Future<void> createTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }
  //mark task as completed
Future<void>completeTask(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      task.isDone = true;// update the task completion status
      await updateTask(task);
    }
}

  List<Task> getTasks() {
    return _taskBox.values.toList();
  }
}
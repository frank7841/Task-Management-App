import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());
final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref){
  return TaskListNotifier(ref.watch(taskRepositoryProvider));
});
class TaskListNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _taskRepository;

  TaskListNotifier(this._taskRepository) : super([]);

  void addTask(Task task) {
    _taskRepository.addTask(task);
    state = [...state, task];
  }

  void updateTask(Task task) {
    _taskRepository.updateTask(task);
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }

  void deleteTask(String id) {
    _taskRepository.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }

  void getTasks() {
    state = _taskRepository.getTasks();
  }
}
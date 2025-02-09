import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());
final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier(ref.watch(taskRepositoryProvider));
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _taskRepository;
  bool _isSyncing = false; //track the syncing process state
  bool _isOnline = false; //track offline or online status

  TaskListNotifier(this._taskRepository) : super([]) {
    getTasks(); //fetch tasks from the repository on initialisation
  }

  //toggle online and offline mode
  void toggleOnlineMode() {
    _isOnline = !_isOnline;
    if (_isOnline) {
      syncTasks(); //sync tasks from firestore when online
    }
  }

  void addTask(Task task) {
    _taskRepository.createTask(task);
    state = [...state, task]; //update the state with new task
  }

  void updateTask(Task task) {
    _taskRepository.updateTask(task);
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }

  void deleteTask(String id) {
    _taskRepository.deleteTask(id);
    state = state
        .where((t) => t.id != id)
        .toList(); //removes the task from the state
  }

  void completeTask(String id) {
    _taskRepository.completeTask(id);
    final task = state.firstWhere((t) => t.id == id);
    task.isDone = true; //mark the task as completed
    updateTask(task); //update task in the state
  }

  void getTasks() {
    state = _taskRepository.getTasks();
  }

  //Sync tasks from firestore
  Future<void> syncTasks() async {
    if (_isOnline) {
      _isSyncing = true; //set syncing state to true
      state = [...state]; //refresh the state
      await _taskRepository.syncTasksFromFirestore(); // sync with firestore

      getTasks(); //refresh the state with the updated tasks
      _isSyncing = false; //set syncing state to false
    }
  }
}

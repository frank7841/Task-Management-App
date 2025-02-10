import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:task_management_app/providers/auth_provider.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../services/firestore_service.dart';

// Hive Box Provider
final hiveBoxProvider = Provider<Box<Task>>((ref) {
  throw UnimplementedError(); // Override in main.dart or test setup
});

// Firestore Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final box = ref.watch(hiveBoxProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    throw Exception("User is not authenticated"); // Prevent null user ID usage
  }

  return TaskRepository(box, firestoreService, userId);
});

final taskListProvider =
StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return TaskListNotifier(taskRepository: taskRepository);
});


class TaskListNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _taskRepository;
  bool _isSyncing = false; // Track syncing state
  bool _isOnline = false; // Track online status

  TaskListNotifier({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super([]) {
    getTasks(); // Fetch tasks from the repository on initialization
  }


  //toggle online and offline mode
  void toggleOnlineMode(bool value) {
    _isOnline = value; // set the toggle value to be user defined
    if (_isOnline) {
      syncTasks(); //sync tasks from firestore when online
    }
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

  void addTask(Task task) {
    final userId = _taskRepository.userId;
    _taskRepository.createTask(task,userId );
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

  bool get isOnline => _isOnline; // Getter for online status
  bool get isSyncing => _isSyncing; // Getter for syncing status
}

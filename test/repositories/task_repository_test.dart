import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/repositories/task_repository.dart';
import 'package:task_management_app/services/firestore_service.dart';

import 'task_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<Task>>(), MockSpec<FirestoreService>()])
void main() {
  late TaskRepository taskRepository;
  late MockBox mockTaskBox; // Correctly typed
  late MockFirestoreService mockFirestoreService;
  late ProviderContainer container;
  String userId = 'testUser123';

  setUp(() {
    mockTaskBox = MockBox(); // Correctly instantiated
    mockFirestoreService = MockFirestoreService();
    taskRepository = TaskRepository(mockTaskBox, mockFirestoreService, userId);
    container = ProviderContainer(overrides: [
      hiveBoxProvider.overrideWithValue(mockTaskBox),
    ]);

    //  Fixes incorrect mock
    when(mockTaskBox.put(any, any)).thenAnswer((_) async => {});
    when(mockFirestoreService.addTask(any, any))
        .thenAnswer((_) async => {}); //  Fixes incorrect parameters
  });

  test('createTask() should save task to Hive and Firestore', () async {
    final task = Task(
        id: '1',
        title: 'Test Task',
        isDone: false,
        description: 'test desc 1',
        lastUpdated: DateTime.now());

    await taskRepository.createTask(task, userId);

    verify(mockTaskBox.put(task.id, task)).called(1);
    verify(mockFirestoreService.addTask(task as String?, userId as Task?))
        .called(1); // Fixes missing argument
  });

  test('updateTask() should update a task in Hive and Firestore', () async {
    final task = Task(
      id: '1',
      title: 'Updated Task',
      isDone: false,
      description: 'Updated desc',
      lastUpdated: DateTime.now(),
    );

    await taskRepository.updateTask(task);

    verify(mockTaskBox.put(task.id, task)).called(1);
    verify(mockFirestoreService.updateTask(task as String?, userId as Task?))
        .called(1);
  });

  test('deleteTask() should remove a task from Hive and Firestore', () async {
    const taskId = '1';

    await taskRepository.deleteTask(taskId);

    verify(mockTaskBox.delete(taskId)).called(1);
    verify(mockFirestoreService.deleteTask(taskId, userId)).called(1);
  });

  test('completeTask() should mark a task as completed', () async {
    final originalTask = Task(
      id: '1',
      title: 'Incomplete Task',
      isDone: false,
      description: 'Mark as complete',
      lastUpdated: DateTime.now(),
    );

    when(mockTaskBox.get('1')).thenReturn(originalTask);

    await taskRepository.completeTask('1');

    //  Ensures the new task instance has `isDone = true`
    final updatedTask = Task(
      id: originalTask.id,
      title: originalTask.title,
      isDone: true,
      // ✅ Ensure completed state
      description: originalTask.description,
      lastUpdated: originalTask.lastUpdated,
    );

    verify(mockTaskBox.put('1', updatedTask)).called(1);
    verify(mockFirestoreService.updateTask(
            updatedTask as String?, userId as Task?))
        .called(1);
  });

  test('syncTasksFromFirestore() should fetch and store tasks in Hive',
      () async {
    final tasks = [
      Task(
          id: '1',
          title: 'Task 1',
          isDone: false,
          description: 'Desc 1',
          lastUpdated: DateTime.now()),
      Task(
          id: '2',
          title: 'Task 2',
          isDone: true,
          description: 'Desc 2',
          lastUpdated: DateTime.now()),
    ];

    when(mockFirestoreService.fetchTasks(userId))
        .thenAnswer((_) async => tasks);

    await taskRepository.syncTasksFromFirestore();

    for (var task in tasks) {
      verify(mockTaskBox.put(task.id, task)).called(1);
    }
  });
}

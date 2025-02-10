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
  late MockBox mockTaskBox; //  Ensure correct type
  late MockFirestoreService mockFirestoreService;
  late ProviderContainer container;
  String userId = 'testUser123';

  setUp(() {
    mockTaskBox = MockBox(); // Correct instantiation
    mockFirestoreService = MockFirestoreService();
    taskRepository = TaskRepository(mockTaskBox, mockFirestoreService, userId);
    container = ProviderContainer(overrides: [
      hiveBoxProvider.overrideWithValue(mockTaskBox),
    ]);

    when(mockTaskBox.put(any, any)).thenAnswer((_) async => {});
    when(mockFirestoreService.addTask(any, any)).thenAnswer((_) async => {});
    when(mockFirestoreService.updateTask(any, any)).thenAnswer((_) async => {});
    when(mockFirestoreService.deleteTask(any, any)).thenAnswer((_) async => {});
    when(mockTaskBox.get(any)).thenReturn(null); // Default behavior for `get`
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
    verify(mockFirestoreService.addTask(userId, task)).called(1); // Fix type
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
    verify(mockFirestoreService.updateTask(userId, task)).called(1); // Fix type
  });
  test('deleteTask() should remove a task from Hive and Firestore', () async {
    // Arrange
    when(mockTaskBox.delete(any)).thenAnswer((_) async {});
    when(mockFirestoreService.deleteTask(any, any)).thenAnswer((_) async {});

    // Act
    await taskRepository.deleteTask('1'); // Ensure this is awaited

    // Assert
    verify(mockTaskBox.delete('1')).called(1);
    verify(mockFirestoreService.deleteTask('testUser123', '1'))
        .called(1); // Ensure correct userId and taskId
  });

  test('completeTask() should mark a task as completed', () async {
    // Arrange
    final task = Task(
        id: '1',
        title: 'Test Task',
        isDone: false,
        description: 'test desc 1',
        lastUpdated: DateTime.now());
    when(mockTaskBox.get('1')).thenReturn(task);
    when(mockTaskBox.put(any, any)).thenAnswer((_) async {});

    // Act
    await taskRepository.completeTask('1');

    // Assert
    expect(task.isDone, true); // Check if task is marked complete
    verify(mockTaskBox.put('1', task)).called(1);
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

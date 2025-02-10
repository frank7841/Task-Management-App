import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/repositories/task_repository.dart';
import 'package:task_management_app/services/firestore_service.dart';

import 'task_repository_test.mocks.dart';

// Use GenerateNiceMocks to preserve type parameters
@GenerateNiceMocks([MockSpec<Box<Task>>(), MockSpec<FirestoreService>()])
void main() {
  late TaskRepository taskRepository;
  late MockBox mockTaskBox;
  late MockFirestoreService mockFirestoreService;

  setUp(() {
    mockTaskBox = MockBox(); // Correctly mock Box<Task>
    mockFirestoreService = MockFirestoreService();
    taskRepository = TaskRepository(mockTaskBox, mockFirestoreService);

    // Mock Hive box behavior
    when(mockTaskBox.put(any, any)).thenAnswer((_) async => {});
    when(mockFirestoreService.addTask(any)).thenAnswer((_) async => {});
  });
  test('createTask() should save task to Hive and Firestore', () async {
    final task = Task(
        id: '1',
        title: 'Test Task',
        isDone: false,
        description: 'test desc 1',
        lastUpdated: DateTime.now());

    await taskRepository.createTask(task);

    // Verify task is saved in Hive
    verify(mockTaskBox.put(task.id, task)).called(1);

    // Verify task is saved in Firestore
    verify(mockFirestoreService.addTask(task)).called(1);
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
    verify(mockFirestoreService.updateTask(task)).called(1);
  });
  test('deleteTask() should remove a task from Hive and Firestore', () async {
    const taskId = '1';

    await taskRepository.deleteTask(taskId);

    verify(mockTaskBox.delete(taskId)).called(1);
    verify(mockFirestoreService.deleteTask(taskId)).called(1);
  });
  test('completeTask() should mark a task as completed', () async {
    final task = Task(
      id: '1',
      title: 'Incomplete Task',
      isDone: false,
      description: 'Mark as complete',
      lastUpdated: DateTime.now(),
    );

    when(mockTaskBox.get('1')).thenReturn(task);

    await taskRepository.completeTask('1');

    expect(task.isDone, true);
    verify(mockTaskBox.put('1', task)).called(1);
    verify(mockFirestoreService.updateTask(task)).called(1);
  });
  test('syncTasksFromFirestore() should fetch and store tasks in Hive', () async {
    final tasks = [
      Task(id: '1', title: 'Task 1', isDone: false, description: 'Desc 1', lastUpdated: DateTime.now()),
      Task(id: '2', title: 'Task 2', isDone: true, description: 'Desc 2', lastUpdated: DateTime.now()),
    ];

    when(mockFirestoreService.fetchTasks()).thenAnswer((_) async => tasks);

    await taskRepository.syncTasksFromFirestore();

    for (var task in tasks) {
      verify(mockTaskBox.put(task.id, task)).called(1);
    }
  });
}

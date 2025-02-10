import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger();
// Fetch user-specific tasks collection
  CollectionReference<Task> _taskCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .withConverter<Task>(
      fromFirestore: (snapshot, _) => Task.fromMap(snapshot.data()!),
      toFirestore: (task, _) => task.toMap(),
    );
  }
  //Add new task document to firestore
  Future<void> addTask(String userId, Task task) async {
    try {
      await _taskCollection(userId).doc(task.id).set(task);
      logger.i('Task added successfully for user: $userId');
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }
  //update existing task in firestore
Future<void> updateTask(String userId, Task task) async {
  try {
    final taskRef = _taskCollection(userId).doc(task.id);
    final remoteTaskDoc = await taskRef.get();

    if (remoteTaskDoc.exists) {
      final remoteTask = remoteTaskDoc.data()!;
      if (remoteTask.lastUpdated.isAfter(task.lastUpdated)) {
        logger.d('Conflict detected: Remote task is newer. Local changes discarded.');
        return;
      }
    }

    await taskRef.update(task.toMap());
    logger.i('Task updated successfully for user: $userId');
  } catch (e) {
    logger.e('Error updating task: $e');
  }
}

  //delete task from firestore
Future<void> deleteTask(String userId, String id) async {
  try {
    await _taskCollection(userId).doc(id).delete();
    logger.i('Task deleted successfully for user: $userId');
  } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
  //retrieve all tasks from firestore
  Future<List<Task>> fetchTasks(String userId) async {
    try {
      final querySnapshot = await _taskCollection(userId).get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger();

  //Add new task document to firestore
  Future<void> addTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).set(task.toMap());
      logger.i('Task added successfully');
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }
  //update existing task in firestore
Future<void> updateTask(Task task) async {
  try {
    // Get the remote task from Firestore
    final remoteTaskDoc = await _firestore.collection('tasks').doc(task.id).get();

    // Check if the remote task exists and compare timestamps
    if (remoteTaskDoc.exists) {
      final remoteTask = Task.fromMap(remoteTaskDoc.data()!); // Convert Firestore data to Task
      if (remoteTask.lastUpdated.isAfter(task.lastUpdated)) {
        // Remote task is newer, so discard the local update
        logger.d('Conflict detected: Remote task is newer. Local changes discarded.');
        return;
      }
    }

    // Save the updated task to Firestore
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());

    logger.i('Task updated successfully.');
  } catch (e) {
    logger.e('Error updating task: $e');
  }
}

  //delete task from firestore
Future<void> deleteTask(String id) async {
    try {
      await _firestore.collection('tasks').doc(id).delete();
      logger.i('Task deleted successfully');
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
  //retrieve all tasks from firestore
  Future<List<Task>> fetchTasks() async {
    try {
      final querySnapshot = await _firestore.collection('tasks').get();
      return querySnapshot.docs.map((doc) {
        // Get the data as a Map<String, dynamic>
        final data = doc.data();
        if (data == null) {
          throw Exception('Document data is null');
        }
        return Task.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }
}

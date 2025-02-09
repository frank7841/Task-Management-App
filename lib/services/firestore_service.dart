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
      await _firestore.collection('tasks').doc(task.id).update(task.toMap());
      logger.i('Task updated successfully');
    } catch (e) {
      throw Exception('Failed to update task: $e');
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
      return querySnapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }
}

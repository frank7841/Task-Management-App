import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'task.g.dart'; // This will be generated

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  bool isDone; // Field to track task completion

  @HiveField(4)
  final DateTime lastUpdated;
  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false, // Default to not completed
    required this.lastUpdated, //Adding a timestamp
  });



  // Factory constructor for creating a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isDone: map['isDone'] as bool? ?? false,
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  // Method to convert Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'lastUpdated':lastUpdated
    };
  }

  // Factory method to create a new Task with updated values
  Task update({
    String? title,
    String? description,
    bool? isDone,
    DateTime? lastUpdated,
  }) {
    return Task(
      id: id, // Keep the same ID
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
//TODO use changeNotifierProvider instead of stateNotifierProvider
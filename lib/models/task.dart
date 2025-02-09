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

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false, // Default to not completed
  });

  // Factory constructor for creating a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isDone: map['isDone'] as bool? ?? false,
    );
  }

  // Method to convert Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }
}//TODO use changeNotifierProvider instead of stateNotifierProvider
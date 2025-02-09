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
}
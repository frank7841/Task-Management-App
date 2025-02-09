import 'package:hive/hive.dart';

part 'task.g.dart'; // This line is required

@HiveType(typeId: 0) // Unique typeId for Hive
class Task {
  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isDone = false,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  bool isDone;
//Copy with to allow updating specific task properties
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
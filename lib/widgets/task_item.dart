import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/providers/task_provider.dart';

import '../models/task.dart';

class TaskItem extends ConsumerWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Row(
        children: [
          Checkbox(
              value: task.isDone,
              onChanged: (bool? value) {
                if (value != null) {
                  ref.read(taskListProvider.notifier).completeTask(task.id);
                }
              }),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(task.description),
      trailing: IconButton(
        onPressed: () {
          ref.read(taskListProvider.notifier).deleteTask(task.id);
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/screens/task_detail_screen.dart';
import 'package:task_management_app/widgets/task_item.dart';

import '../models/task.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management App'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskItem(task: task);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(taskListProvider.notifier).addTask(
                Task(
                  id: DateTime.now().toString(),
                  title: 'Task ${tasks.length + 1}',
                  description: 'Description ${tasks.length + 1}',
                ),
              );
          Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

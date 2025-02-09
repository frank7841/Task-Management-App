import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/screens/edit_task_screen.dart';
import 'package:task_management_app/screens/task_detail_screen.dart';
import 'package:task_management_app/widgets/task_item.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    final tasks = ref.watch(taskListProvider);
    final isSyncing = ref.watch(taskListProvider.notifier).isSyncing;
    final isOnline = ref.watch(taskListProvider.notifier).isOnline;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management App'),
        actions: [
          ToggleSwitch(
            minWidth: 60.0,
            initialLabelIndex: isOnline ? 1 : 0,
            // Set initial index based on online state
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: const ['Off', 'On'],
            icons: const [Icons.offline_bolt, Icons.wifi],
            // Use appropriate icons
            activeBgColors: const [
              [Colors.red],
              [Colors.green]
            ],
            // Colors for active states
            onToggle: (index) {
              logger.d('switched to: $index');
              ref
                  .read(taskListProvider.notifier)
                  .toggleOnlineMode(index == 1); // Update online state
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSyncing) const LinearProgressIndicator(),
          //show progress indicator when syncing
          if (tasks.isEmpty) const Text('No tasks found'),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskItem(
                  task: task,
                  onTap: () {
                    //Navigate to Edit task screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTaskScreen(task: task)));
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => TaskDetailScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

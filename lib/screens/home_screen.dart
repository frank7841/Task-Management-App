import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/screens/task_detail_screen.dart';
import 'package:task_management_app/widgets/task_item.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final isSyncing = ref.watch(taskListProvider.notifier).isSyncing;
    final isOnline = ref.watch(taskListProvider.notifier).isOnline;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management App'),
        actions: [
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: isOnline ? 1 : 0,
            // Set initial index based on online state
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: ['Offline', 'Online'],
            icons: [Icons.offline_bolt, Icons.wifi],
            // Use appropriate icons
            activeBgColors: [
              [Colors.red],
              [Colors.green]
            ],
            // Colors for active states
            onToggle: (index) {
              print('switched to: $index');
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
                return TaskItem(task: task);
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

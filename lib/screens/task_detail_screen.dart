import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final _basicFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _basicFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  // Validate the title field
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title'; // Return error message if empty
                  }
                  return null; // Return null if valid
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  // Validate the description field
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description'; // Return error message if empty
                  }
                  return null; // Return null if valid
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Check if the form is valid
                  if (_basicFormKey.currentState!.validate()) {
                    // If valid, create a new task
                    final newTask = Task(
                      id: DateTime.now().toString(), // Generate a unique ID
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      lastUpdated: DateTime.now()
                    );

                    // Log the task details before adding
                    logger.d("Creating task: Title: '${newTask.title}', Description: '${newTask.description}'");

                    // Add the new task to the state
                    ref.read(taskListProvider.notifier).addTask(newTask);

                    // Clear the text fields
                    _titleController.clear();
                    _descriptionController.clear();

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  } else {
                    // If the form is invalid, log a message
                    logger.w("Form is invalid, not adding task.");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields.')),
                    );
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
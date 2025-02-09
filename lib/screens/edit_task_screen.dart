import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/providers/task_provider.dart';

import '../models/task.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Task task;

  const EditTaskScreen({required this.task, Key? key}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current task's data
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _isDone = widget.task.isDone;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')), // App bar with a title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            children: [
              // Title input field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title'; // Validation message
                  }
                  return null;
                },
              ),
              // Description input field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              // Checkbox to mark the task as completed
              CheckboxListTile(
                title: const Text('Completed'),
                value: _isDone,
                onChanged: (value) {
                  setState(() {
                    _isDone = value ?? false; // Update the completion status
                  });
                },
              ),
              // Save button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Create an updated task object
                    final updatedTask = widget.task.update(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      isDone: _isDone,
                    );

                    // Update the task in the repository
                    ref.read(taskListProvider.notifier).updateTask(updatedTask);

                    // Navigate back to the home screen
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

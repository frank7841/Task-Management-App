import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends ConsumerWidget{
  final _basicFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },//Validate the form field to ensure it is not empty
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },//Validate the form field to ensure it is not empty
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_basicFormKey.currentState!.validate()) {
                    ref.read(taskListProvider.notifier).addTask(
                      Task(
                        id: DateTime.now().toString(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),

      )
    );
  }
}
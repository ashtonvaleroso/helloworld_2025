import 'package:flutter/material.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/task.dart';
import 'package:provider/provider.dart';

/// Model that holds all controllers, values, and task operations
class TaskDialogModel extends ChangeNotifier {
  final TextEditingController nameController;
  final TextEditingController estimatedTimeController;
  final TextEditingController priorityController;

  DateTime startDate;
  DateTime dueDate;

  Task? task; // null if creating new

  TaskDialogModel({this.task})
      : nameController = TextEditingController(text: task?.name ?? ''),
        estimatedTimeController =
            TextEditingController(text: task?.estimatedTime.toString() ?? ''),
        priorityController =
            TextEditingController(text: task?.priority.toString() ?? '2'),
        startDate = task?.startDate ?? DateTime.now(),
        dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));

  /// Setters with notifyListeners
  void setStartDate(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  void setDueDate(DateTime date) {
    dueDate = date;
    notifyListeners();
  }

  /// Delete the task if editing
  void deleteTask() {
    if (task != null) {
      repository.deleteTask(task!.id);
    }
  }

  /// Save or create task
  void saveTask() {
    final name = nameController.text.trim();
    final estimatedTime = double.tryParse(estimatedTimeController.text) ?? 0;
    final priority = int.tryParse(priorityController.text) ?? 2;

    if (name.isEmpty) return;

    final newTask = Task(
      id: task?.id ?? 0,
      name: name,
      estimatedTime: estimatedTime,
      startDate: startDate,
      dueDate: dueDate,
      priority: priority,
    );

    repository.insertTask(newTask);
  }

  /// Dispose controllers
  void disposeControllers() {
    nameController.dispose();
    estimatedTimeController.dispose();
    priorityController.dispose();
  }
}

/// Stateless dialog purely for UI
class TaskDialog extends StatelessWidget {
  const TaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskDialogModel(),
      builder: (context, child) {
        final model = Provider.of<TaskDialogModel>(context);
        final isEditing = model.task != null;

        Future<void> pickDate({required bool isStart}) async {
          final picked = await showDatePicker(
            context: context,
            initialDate: isStart ? model.startDate : model.dueDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            if (isStart) {
              model.setStartDate(picked);
            } else {
              model.setDueDate(picked);
            }
          }
        }

        return AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: model.nameController,
                  decoration: const InputDecoration(labelText: 'Task Name'),
                ),
                TextField(
                  controller: model.estimatedTimeController,
                  decoration: const InputDecoration(
                      labelText: 'Estimated Time (hours)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: model.priorityController,
                  decoration:
                      const InputDecoration(labelText: 'Priority (1-3)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Start:'),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => pickDate(isStart: true),
                      child: Text("${model.startDate.toLocal()}".split(' ')[0]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Due:'),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => pickDate(isStart: false),
                      child: Text("${model.dueDate.toLocal()}".split(' ')[0]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            if (isEditing)
              TextButton(
                onPressed: () {
                  model.deleteTask();
                  Navigator.pop(context);
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                model.saveTask();
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Save' : 'Create'),
            ),
          ],
        );
      },
    );
  }
}

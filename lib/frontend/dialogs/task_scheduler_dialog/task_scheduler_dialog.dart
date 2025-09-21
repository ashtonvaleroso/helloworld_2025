import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld_2025/frontend/dialogs/task_scheduler_dialog/task_scheduler_dialog_model.dart';
import 'package:provider/provider.dart';

class TaskSchedulerDialog extends StatelessWidget {
  const TaskSchedulerDialog({super.key});

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskSchedulerModel(),
      builder: (context, child) {
        final model = context.watch<TaskSchedulerModel>();

        return AlertDialog(
          title: const Text("Schedule Tasks"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => context
                        .read<TaskSchedulerModel>()
                        .scheduleAllAfterNow(context),
                    child: const Text("This Week"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

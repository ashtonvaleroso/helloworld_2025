import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld_2025/backend/user.dart';
import 'package:helloworld_2025/frontend/dialogs/task_dialog.dart';
import 'package:helloworld_2025/frontend/dialogs/task_scheduler_dialog/task_scheduler_dialog.dart';
import 'package:helloworld_2025/frontend/dialogs/task_scheduler_dialog/task_scheduler_dialog_model.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TaskSchedulerModel.scheduleTasks(
                      //     user: User.defaultUser,
                      //     events: repository.getEvents(),
                      //     tasks: repository.getTasks(),
                      //     start: DateTime.now(),
                      //     end: DateTime.now().add(Duration(days: 7)));
                    },
                    child: Text(
                      'Tasks',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    DialogRoute(
                      context: context,
                      builder: (context) => TaskSchedulerDialog(),
                    ),
                  ),
                  label: Text('Schedule Tasks'),
                  icon: Icon(Icons.schedule),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: repository.streamTasks(),
              builder: (context, snapshot) {
                final tasks = snapshot.data ?? repository.getTasks();

                if (tasks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No tasks yet.'),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final priorityColor = {
                          1: Colors.red,
                          2: Colors.orange,
                          3: Colors.green,
                        }[task.priority] ??
                        Colors.grey;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: priorityColor.withOpacity(0.2),
                          child: Text(
                            task.priority.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                        ),
                        title: Text(
                          task.name,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 16),
                                const SizedBox(width: 4),
                                Text("${task.estimatedTime} hrs"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.play_arrow, size: 16),
                                const SizedBox(width: 4),
                                Text("Start: ${_formatDate(task.startDate)}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.flag, size: 16),
                                const SizedBox(width: 4),
                                Text("Due: ${_formatDate(task.dueDate)}"),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          DialogRoute(
                            context: context,
                            builder: (context) => TaskDialog(
                              task: task,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

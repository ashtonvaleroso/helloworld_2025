import 'package:flutter/material.dart';
import 'package:helloworld_2025/backend/user.dart';
import 'package:helloworld_2025/backend/work_block.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/objectbox/task.dart';

class TaskSchedulerModel extends ChangeNotifier {
  User user = User.defaultUser;

  List<Task> get tasks => repository.getTasks();
  List<Event> get events => repository.getEvents();

  final List<WorkBlock> _scheduledBlocks = [];
  List<WorkBlock> get scheduledBlocks => _scheduledBlocks;

  TaskSchedulerModel();

  /// Schedule all tasks starting strictly after now
  void scheduleAllAfterNow(BuildContext context) {
    final now = DateTime.now();
    // Arbitrary far future end (e.g., 1 year from now) to schedule all tasks
    final end = now.add(Duration(days: 365));
    _scheduleTasksForRange(now, end);
    notifyListeners();
    Navigator.pop(context);
  }

  /// Core scheduling logic
  void _scheduleTasksForRange(DateTime start, DateTime end) {
    List<Event> allEvents = List<Event>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    List<Task> remainingTasks = List<Task>.from(tasks)
      ..sort((a, b) => a.priority.compareTo(b.priority));

    DateTime currentDay = DateTime(start.year, start.month, start.day);

    while (remainingTasks.isNotEmpty &&
        (currentDay.isBefore(end) || currentDay.isAtSameMomentAs(end))) {
      DateTime workStart = DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day,
        user.workingHoursStart,
      );
      DateTime workEnd = DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day,
        user.workingHoursEnd,
      );

      // Ensure workStart is after "start" (DateTime.now())
      if (workStart.isBefore(start)) workStart = start;

      // Skip day if working hours are already past
      if (!workStart.isBefore(workEnd)) {
        currentDay = currentDay.add(Duration(days: 1));
        continue;
      }

      // Events for the day
      List<Event> todayEvents = allEvents
          .where((e) =>
              e.startTime.isBefore(workEnd) && e.endTime.isAfter(workStart))
          .toList();

      // Free blocks
      List<WorkBlock> freeBlocks =
          _getFreeBlocks(workStart, workEnd, todayEvents);

      for (var block in freeBlocks) {
        if (remainingTasks.isEmpty) break;

        Task task = remainingTasks.first;

        // If task fits in block
        if ((block.end.difference(block.start).inMinutes / 60.0) >=
            task.estimatedTime) {
          DateTime taskStart = block.start;
          DateTime taskEnd = taskStart
              .add(Duration(minutes: (task.estimatedTime * 60).toInt()));

          // Insert as event
          Event newEvent = Event(
            title: task.name,
            startTime: taskStart,
            endTime: taskEnd,
            colorValue: priorityColorValue(task.priority),
            isFixed: true,
          );

          repository.insertEvent(newEvent);
          repository.deleteTask(task.id);

          _scheduledBlocks
              .add(WorkBlock(start: taskStart, end: taskEnd, task: task));

          block.start = taskEnd; // Update block start for next task
          remainingTasks.removeAt(0);
        }
      }

      currentDay = currentDay.add(Duration(days: 1));
    }
  }

  List<WorkBlock> _getFreeBlocks(
      DateTime start, DateTime end, List<Event> events) {
    List<WorkBlock> freeBlocks = [];

    if (events.isEmpty) {
      freeBlocks.add(WorkBlock(start: start, end: end));
      return freeBlocks;
    }

    DateTime current = start;
    for (var e in events) {
      if (current.isBefore(e.startTime)) {
        freeBlocks.add(WorkBlock(start: current, end: e.startTime));
      }
      if (current.isBefore(e.endTime)) {
        current = e.endTime;
      }
    }

    if (current.isBefore(end)) {
      freeBlocks.add(WorkBlock(start: current, end: end));
    }

    return freeBlocks;
  }

  int priorityColorValue(int priority) {
    final color = {
          1: Colors.red,
          2: Colors.orange,
          3: Colors.green
        }[priority] ??
        Colors.grey;
    return color.value;
  }
}

class WorkBlock {
  DateTime start;
  DateTime end;
  Task? task;

  WorkBlock({required this.start, required this.end, this.task});
}

import 'package:flutter/material.dart';
import 'package:helloworld_2025/backend/user.dart';
import 'package:helloworld_2025/backend/work_block.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/objectbox/task.dart';

class RescheduleManager {
  final User user;
  final List<Task> _tasks = [];
  final List<Event> _events = [];

  RescheduleManager(this.user);

  void addTask(Task task) => _tasks.add(task);

  void addEvent(Event event) => _events.add(event);

  bool _isTimeBlocked(DateTime start, DateTime end) {
    for (var event in _events) {
      if (end.isAfter(event.startTime) && start.isBefore(event.endTime)) {
        return true; // overlap
      }
    }
    return false;
  }

  bool _inWorkingHours(DateTime time) {
    final hour = time.hour;
    return hour >= user.workingHours.$1 && hour < user.workingHours.$2;
  }

  List<WorkBlock> _getAvailableSlots(
    DateTime startDate,
    DateTime endDate, {
    double blockDuration = 2.0,
  }) {
    final blocks = <WorkBlock>[];
    var current = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      user.workingHours.$1,
    );

    while (current.isBefore(endDate)) {
      if (_inWorkingHours(current)) {
        final blockEnd = current.add(Duration(
          minutes: (blockDuration * 60).round(),
        ));

        if (blockEnd.hour <= user.workingHours.$2 &&
            !_isTimeBlocked(current, blockEnd)) {
          blocks.add(WorkBlock(startTime: current, duration: blockDuration));
        }
        current = blockEnd;
      } else {
        if (current.hour >= user.workingHours.$2) {
          current = DateTime(
            current.year,
            current.month,
            current.day + 1,
            user.workingHours.$1,
          );
        } else {
          current = DateTime(
            current.year,
            current.month,
            current.day,
            user.workingHours.$1,
          );
        }
      }
    }
    return blocks;
  }

  List<WorkBlock> scheduleTasks({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    startDate ??= DateTime.now();
    endDate ??= startDate.add(const Duration(days: 7));

    final tasks = List<Task>.from(_tasks)
      ..sort((a, b) {
        if (a.priority != b.priority) {
          return a.priority.compareTo(b.priority);
        }
        return a.dueDate.compareTo(b.dueDate);
      });

    final blocks = _getAvailableSlots(startDate, endDate);
    final scheduledBlocks = <WorkBlock>[];

    for (final block in blocks) {
      final toRemove = <Task>[];

      for (final task in tasks) {
        if (task.startDate.isBefore(block.startTime) &&
            task.dueDate.isAfter(block.endTime)) {
          if (block.addTask(task)) {
            toRemove.add(task);
          }
        }
      }
      tasks.removeWhere(toRemove.contains);

      if (block.tasks.isNotEmpty) {
        scheduledBlocks.add(block);
      }
    }

    if (tasks.isNotEmpty) {
      debugPrint("⚠️ Unscheduled tasks:");
      for (final t in tasks) {
        debugPrint(" - ${t.name} (${t.estimatedTime}h, due ${t.dueDate})");
      }
    }

    return scheduledBlocks;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/objectbox/task.dart';

double vw(BuildContext context) => MediaQuery.of(context).size.width;
double vh(BuildContext context) => MediaQuery.of(context).size.height;

/// Round a double to nearest 0.25
double roundToQuarter(double value) {
  return (value * 4).roundToDouble() / 4;
}

Future<void> generateAndSaveWeeklySchedule() async {
  final events = <Event>[];
  final tasks = <Task>[];

  final now = DateTime.now();

  // --- Get next Monday (or today if it's Monday before 9am) ---
  int daysUntilMonday = (8 - now.weekday) % 7;
  DateTime nextMonday = DateTime(now.year, now.month, now.day)
      .add(Duration(days: daysUntilMonday));

  final random = Random();

  // --- Add classes (total 20 hours, Monday-Friday) ---
  final classStartTimes = [9, 10, 11, 14]; // 9am,10am,11am,2pm
  for (int i = 0; i < 5; i++) {
    final day = nextMonday.add(Duration(days: i));
    for (int h in classStartTimes) {
      final start = DateTime(day.year, day.month, day.day, h, 0);
      final end = start.add(const Duration(hours: 1));
      final event = Event(
        title: "Class",
        startTime: start,
        endTime: end,
        colorValue: Colors.blue.value,
        isFixed: true,
      );
      events.add(event);
      repository.insertEvent(event); // save to ObjectBox
    }
  }

  // --- Add homework tasks (total 20 hours) ---
  final taskNames = [
    "Math Homework",
    "Physics Homework",
    "Chemistry Homework",
    "History Essay",
    "Computer Science Project",
  ];

  double totalTaskHours = 20;

  for (int i = 0; i < taskNames.length; i++) {
    double remainingTasks = taskNames.length.toDouble() - i;
    double maxHours = min(2, totalTaskHours); // max 2 hours per task
    double minHours = 0.25; // min 0.25 hours per task

    // Generate random duration between 0.25 and min(2, totalTaskHours)
    double estimated = minHours + random.nextDouble() * (maxHours - minHours);
    estimated = roundToQuarter(estimated);

    // Ensure we don't exceed remaining total hours
    estimated = min(estimated, totalTaskHours);
    totalTaskHours -= estimated;

    final task = Task(
      name: taskNames[i],
      estimatedTime: estimated,
      startDate: nextMonday,
      dueDate: nextMonday.add(const Duration(days: 7)),
      priority: random.nextInt(3) + 1,
      flexible: true,
    );
    tasks.add(task);
    repository.insertTask(task); // save to ObjectBox
  }

  // --- Add a club event Thursday 6-9pm ---
  final thursday = nextMonday.add(const Duration(days: 3));
  final clubEvent = Event(
    title: "Club Meeting",
    startTime: DateTime(thursday.year, thursday.month, thursday.day, 18, 0),
    endTime: DateTime(thursday.year, thursday.month, thursday.day, 21, 0),
    colorValue: Colors.purple.value,
    isFixed: true,
  );
  events.add(clubEvent);
  repository.insertEvent(clubEvent); // save to ObjectBox

  debugPrint(
      "✅ Generated and saved weekly schedule with ${tasks.length} tasks and ${events.length} events starting from ${nextMonday.toLocal()}");
}

import 'package:helloworld_2025/objectbox/task.dart';

class WorkBlock {
  DateTime startTime;
  DateTime endTime;
  List<Task> tasks = [];

  WorkBlock({
    required this.startTime,
    required this.endTime,
    this.tasks = const [],
  });

  /// Returns remaining time in hours
  double get remainingTime {
    final usedMinutes = tasks.fold<int>(
      0,
      (sum, t) => sum + (t.estimatedTime * 60).toInt(),
    );
    final totalMinutes = endTime.difference(startTime).inMinutes;
    return (totalMinutes - usedMinutes) / 60.0;
  }

  /// Try to add a task if it fits into the remaining time
  bool addTask(Task task) {
    if (task.estimatedTime <= remainingTime) {
      tasks.add(task);
      return true;
    }
    return false;
  }

  @override
  String toString() {
    final taskNames = tasks.map((t) => t.name).join(", ");
    return "WorkBlock(${startTime.toIso8601String()} - ${endTime.toIso8601String()}, tasks=[$taskNames], remainingHours=${remainingTime.toStringAsFixed(2)})";
  }
}

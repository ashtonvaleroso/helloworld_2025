import 'package:helloworld_2025/objectbox/task.dart';

class WorkBlock {
  DateTime startTime;
  double duration; // hours
  late DateTime endTime;
  List<Task> tasks = [];
  double remainingTime;

  WorkBlock({
    required this.startTime,
    this.duration = 2.0,
  })  : remainingTime = duration,
        endTime = startTime.add(Duration(
          minutes: (duration * 60).round(),
        ));

  bool addTask(Task task) {
    if (task.estimatedTime <= remainingTime) {
      tasks.add(task);
      remainingTime -= task.estimatedTime;
      return true;
    }
    return false;
  }

  @override
  String toString() {
    final taskNames = tasks.map((t) => t.name).join(", ");
    return "WorkBlock(${startTime.toIso8601String()}, tasks=[$taskNames])";
  }
}

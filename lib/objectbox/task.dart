import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  @Id()
  int id;
  String name;
  double estimatedTime; // hours
  DateTime dueDate;
  DateTime startDate;
  int priority; // 1 = highest, 3 = lowest
  bool flexible;

  Task({
    this.id = 0,
    required this.name,
    required this.estimatedTime,
    required this.dueDate,
    required this.startDate,
    required this.priority,
    this.flexible = true,
  });

  @override
  String toString() =>
      "Task('$name', ${estimatedTime}h, priority=$priority, due=${dueDate.toIso8601String()})";
}

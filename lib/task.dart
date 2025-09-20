import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  @Id()
  int id;
  String title;
  int duration; // in minutes
  int colorValue;

  Task({
    required this.id,
    required this.title,
    required this.duration,
    required this.colorValue,
  });
}

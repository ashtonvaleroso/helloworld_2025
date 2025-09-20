import 'package:objectbox/objectbox.dart';
import 'package:flutter/material.dart';

@Entity()
class Event {
  @Id()
  int id;
  String title;
  DateTime startTime;
  DateTime endTime;
  int colorValue;
  bool isAllDay;

  Event({
    this.id = 0,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.colorValue,
    this.isAllDay = false,
  });

  Color get color => Color(colorValue);
}

import 'package:flutter/material.dart';

class NewEventPageModel extends ChangeNotifier {
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  String? title;
  Color? color;
  bool isAllDay = false;
}

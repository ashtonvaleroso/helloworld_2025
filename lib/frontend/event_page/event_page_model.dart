import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/global/global_variables.dart';

class EventPageModel extends ChangeNotifier {
  final Event? event;
  final bool isNew;
  EventPageModel({
    required this.event,
    required this.isNew,
  }) {
    if (event != null) {
      titleController.text = isNew ? '' : event!.title;
      startTime = event!.startTime;
      endTime = event!.endTime;
      color = parseColor(event!.colorValue);
      isAllDay = event!.isAllDay;
    }
  }

  TextEditingController titleController = TextEditingController();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 1));
  Color color = Colors.blue;
  bool isAllDay = false;

  void setStartTime(DateTime value) {
    // Check if start and end were on the same date
    bool sameDate = startTime.year == endTime.year &&
        startTime.month == endTime.month &&
        startTime.day == endTime.day;

    startTime = value;

    // If they were on the same day, adjust endTime to match new start date
    if (sameDate) {
      endTime = DateTime(
        value.year,
        value.month,
        value.day,
        endTime.hour,
        endTime.minute,
      );

      // Ensure endTime is not before startTime
      if (endTime.isBefore(startTime)) {
        endTime = startTime.add(const Duration(hours: 1));
      }
    } else if (endTime.isBefore(startTime)) {
      // If dates were different, just make sure endTime is after startTime
      endTime = startTime.add(const Duration(hours: 1));
    }

    notifyListeners();
  }

  void setEndTime(DateTime value) {
    if (value.isAfter(startTime)) {
      endTime = value;
      notifyListeners();
    }
  }

  void setColor(Color value) {
    color = value;
    notifyListeners();
  }

  void setAllDay(bool value) {
    isAllDay = value;
    notifyListeners();
  }

  void saveEvent(BuildContext context) {
    if (titleController.text.isEmpty) return;

    final newEvent = Event(
      id: event?.id ?? 0,
      title: titleController.text,
      startTime: startTime,
      endTime: endTime,
      colorValue: color.value,
      isAllDay: isAllDay,
    );

    repository.insertEvent(newEvent);
    Navigator.pop(context);
  }

  void deleteEvent(BuildContext context) {
    if (event != null) {
      repository.deleteEvent(event!.id);
      Navigator.pop(context);
    }
  }

  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setStartTime(DateTime(
          date.year, date.month, date.day, startTime.hour, startTime.minute));
    }
  }

  Future<void> pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime),
    );
    if (time != null) {
      setStartTime(DateTime(startTime.year, startTime.month, startTime.day,
          time.hour, time.minute));
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setEndTime(DateTime(
          date.year, date.month, date.day, endTime.hour, endTime.minute));
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTime),
    );
    if (time != null) {
      setEndTime(DateTime(
          endTime.year, endTime.month, endTime.day, time.hour, time.minute));
    }
  }

  Future<void> pickColor(BuildContext context) async {
    final newColor = await showDialog<Color>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Color'),
        children: [
          SimpleDialogOption(
            child: const Text('Blue'),
            onPressed: () => Navigator.pop(context, Colors.blue),
          ),
          SimpleDialogOption(
            child: const Text('Red'),
            onPressed: () => Navigator.pop(context, Colors.red),
          ),
          SimpleDialogOption(
            child: const Text('Green'),
            onPressed: () => Navigator.pop(context, Colors.green),
          ),
        ],
      ),
    );
    if (newColor != null) setColor(newColor);
  }

  Color parseColor(int value) => Color(value);
}

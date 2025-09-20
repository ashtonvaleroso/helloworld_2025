import 'package:flutter/material.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';

class EventPageModel extends ChangeNotifier {
  final Event? event;
  EventPageModel(this.event) {
    titleController.text = event?.title ?? '';
  }

  TextEditingController titleController = TextEditingController();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 1));
  Color color = Colors.blue;
  bool isAllDay = false;

  void setStartTime(DateTime value) {
    startTime = value;
    notifyListeners();
  }

  void setEndTime(DateTime value) {
    endTime = value;
    notifyListeners();
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

    final event = Event(
      title: titleController.text,
      startTime: startTime,
      endTime: endTime,
      colorValue: color.value,
      isAllDay: isAllDay,
    );

    repository.insertEvent(event);
    Navigator.pop(context);
  }

  Future<void> pickStartDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(startTime),
      );
      if (time != null) {
        setStartTime(
            DateTime(date.year, date.month, date.day, time.hour, time.minute));
      }
    }
  }

  Future<void> pickEndDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(endTime),
      );
      if (time != null) {
        setEndTime(
            DateTime(date.year, date.month, date.day, time.hour, time.minute));
      }
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
}

import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/objectbox/repository.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPageModel extends ChangeNotifier {
  final Repository repository;

  final CalendarController calendarController = CalendarController();
  CalendarPageModel(this.repository);

  CalendarView calendarView = CalendarView.week;

  IconData get iconData {
    switch (calendarView) {
      case CalendarView.day:
        return Icons.calendar_today;
      case CalendarView.week:
        return Icons.view_week;
      case CalendarView.workWeek:
        return Icons.work;
      case CalendarView.month:
        return Icons.calendar_month;
      case CalendarView.schedule:
        return Icons.view_agenda;
      default:
        return Icons.calendar_today;
    }
  }

  void setCalendarView(CalendarView view) {
    calendarView = view;
    notifyListeners();
  }

  List<Event> getEvents() => repository.getEvents();

  Stream<List<Event>> streamEvents() => repository.streamEvents();
}

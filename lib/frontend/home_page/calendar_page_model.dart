import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/objectbox/repository.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPageModel extends ChangeNotifier {
  final Repository repository;

  CalendarPageModel(this.repository);

  CalendarView calendarView = CalendarView.week;

  void setCalendarView(CalendarView view) {
    calendarView = view;
    notifyListeners();
  }

  List<Event> getEvents() => repository.getEvents();

  Stream<List<Event>> streamEvents() => repository.streamEvents();
}

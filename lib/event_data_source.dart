import 'dart:ui';

import 'package:helloworld_2025/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startTime;

  @override
  DateTime getEndTime(int index) => appointments![index].endTime;

  @override
  String getSubject(int index) => appointments![index].title;

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}

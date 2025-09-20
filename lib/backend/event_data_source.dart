import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox/event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  /// 👇 Needed for drag-and-drop & editing
  @override
  Object? convertAppointmentToObject(
      Object? customData, Appointment appointment) {
    if (customData is Event) {
      return Event(
        id: customData.id,
        title: appointment.subject,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        colorValue: appointment.color.value,
        isAllDay: appointment.isAllDay,
      );
    }
    return null;
  }
}

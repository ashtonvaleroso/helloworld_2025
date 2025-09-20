import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld_2025/backend/event_data_source.dart';
import 'package:helloworld_2025/frontend/home_page/calendar_page_model.dart';
import 'package:helloworld_2025/frontend/event_page/event_page.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarPageModel(repository),
      builder: (context, child) {
        final readCalendarPage = context.read<CalendarPageModel>();
        final watchCalendarPage = context.watch<CalendarPageModel>();

        return StreamBuilder<List<Event>>(
          stream: repository.streamEvents(),
          builder: (context, snapshot) {
            final events = snapshot.data ?? repository.getEvents();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: Text(
                  'Flexender',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: "Jump to Today",
                    icon: const Icon(Icons.today, color: Colors.white),
                    onPressed: () {
                      readCalendarPage.calendarController.displayDate =
                          DateTime.now();
                    },
                  ),
                  PopupMenuButton<CalendarView>(
                    icon: Icon(
                      watchCalendarPage.iconData,
                      color: Colors.white,
                    ),
                    onSelected: (view) {
                      readCalendarPage.calendarController.view = view;
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: CalendarView.schedule,
                        child: Text('Schedule'),
                      ),
                      const PopupMenuItem(
                        value: CalendarView.day,
                        child: Text('Daily'),
                      ),
                      const PopupMenuItem(
                        value: CalendarView.week,
                        child: Text('Weekly'),
                      ),
                      const PopupMenuItem(
                        value: CalendarView.month,
                        child: Text('Monthly'),
                      ),
                    ],
                  ),
                ],
              ),
              body: SfCalendar(
                showDatePickerButton: true,
                cellBorderColor: Colors.grey,
                controller: watchCalendarPage.calendarController,
                view: watchCalendarPage.calendarView,
                dataSource: EventDataSource(events),
                allowDragAndDrop: true,
                dragAndDropSettings: const DragAndDropSettings(
                  showTimeIndicator: true,
                  indicatorTimeFormat: 'h:mm a',
                ),
                onTap: (calendarTapDetails) {
                  if ((calendarTapDetails.appointments ?? []).isNotEmpty) {
                    final event = calendarTapDetails.appointments![0];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventPage(event: event),
                      ),
                    );
                  }
                },
                onDragEnd: (details) {
                  final event = details.appointment as Event;
                  final newStart = details.droppingTime!;
                  final duration = event.endTime.difference(event.startTime);
                  final newEnd = newStart.add(duration);

                  repository.insertEvent(Event(
                    id: event.id,
                    title: event.title,
                    colorValue: event.colorValue,
                    startTime: newStart,
                    endTime: newEnd,
                  ));
                },
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventPage(),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:helloworld_2025/backend/event_data_source.dart';
import 'package:helloworld_2025/frontend/home_page/calendar_page_model.dart';
import 'package:helloworld_2025/frontend/event_page/event_page.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarPageModel(repository),
      builder: (context, model) {
        final readCalendarPage = context.read<CalendarPageModel>();
        final watchCalendarPage = context.watch<CalendarPageModel>();
        return StreamBuilder<List<Event>>(
          stream: repository.streamEvents(),
          builder: (context, snapshot) {
            final events = snapshot.data ?? repository.getEvents();
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(title),
                actions: [
                  PopupMenuButton<CalendarView>(
                    icon: const Icon(Icons.view_agenda),
                    onSelected: readCalendarPage.setCalendarView,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: CalendarView.schedule,
                        child: Text('Schedule View'),
                      ),
                      const PopupMenuItem(
                        value: CalendarView.day,
                        child: Text('Daily View'),
                      ),
                      const PopupMenuItem(
                        value: CalendarView.week,
                        child: Text('Weekly View'),
                      ),
                      const PopupMenuItem(
                        value: CalendarView.month,
                        child: Text('Monthly View'),
                      ),
                    ],
                  ),
                ],
              ),
              body: SfCalendar(
                key: ValueKey(watchCalendarPage.calendarView),
                view: watchCalendarPage.calendarView,
                dataSource: EventDataSource(events),
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

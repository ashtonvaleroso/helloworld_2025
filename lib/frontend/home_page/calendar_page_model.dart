import 'package:flutter/material.dart';
import 'package:helloworld_2025/backend/event_data_source.dart';
import 'package:helloworld_2025/frontend/dialogs/new_event_dialog.dart';
import 'package:helloworld_2025/frontend/home_page/calendar_page.dart';
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
      child: Consumer<CalendarPageModel>(
        builder: (context, model, _) {
          return StreamBuilder<List<Event>>(
            stream: model.streamEvents(),
            builder: (context, snapshot) {
              final events = snapshot.data ?? model.getEvents();
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text(title),
                ),
                body: SfCalendar(
                  view: CalendarView.week,
                  dataSource: EventDataSource(events),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final newEvent = await showDialog<Event>(
                      context: context,
                      builder: (_) => const NewEventDialog(),
                    );
                    if (newEvent != null) {
                      model.addEvent(newEvent);
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld_2025/backend/event_data_source.dart';
import 'package:helloworld_2025/frontend/components/new_item_modalsheet.dart';
import 'package:helloworld_2025/frontend/home_page/calendar_page_model.dart';
import 'package:helloworld_2025/frontend/event_page/event_page.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/task_list/task_list.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarPageModel(repository),
      builder: (context, child) {
        final readModel = context.read<CalendarPageModel>();
        final watchModel = context.watch<CalendarPageModel>();

        return StreamBuilder<List<Event>>(
          stream: repository.streamEvents(),
          builder: (context, snapshot) {
            final events = snapshot.data ?? repository.getEvents();

            return Scaffold(
              appBar: _buildAppBar(context, readModel, watchModel),
              body: MultiSplitViewTheme(
                data: MultiSplitViewThemeData(
                  dividerThickness: 20,
                ),
                child: MultiSplitView(
                  axis: Axis.vertical,
                  resizable: true,
                  dividerBuilder: (axis, index, resizable, dragging,
                      highlighted, themeData) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.resizeRow,
                      child: Container(
                        color:
                            Colors.grey.shade500, // make outer area invisible
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 4,
                            decoration: BoxDecoration(
                              color: dragging
                                  ? Colors.blueAccent
                                  : highlighted
                                      ? Colors.blueGrey
                                      : Colors.grey[600],
                              borderRadius:
                                  BorderRadius.circular(2), // rounded edges
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  initialAreas: [
                    Area(
                      flex: 2,
                      min: 1.2,
                      builder: (context, area) => _buildCalendarArea(
                          context, events, watchModel, readModel),
                    ),
                    Area(
                      flex: 1,
                      min: 0.25,
                      builder: (context, area) => TaskList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, CalendarPageModel readModel,
      CalendarPageModel watchModel) {
    return AppBar(
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
            readModel.calendarController.displayDate = DateTime.now();
          },
        ),
        PopupMenuButton<CalendarView>(
          icon: Icon(watchModel.iconData, color: Colors.white),
          onSelected: (view) {
            readModel.calendarController.view = view;
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
                value: CalendarView.schedule, child: Text('Schedule')),
            PopupMenuItem(value: CalendarView.day, child: Text('Daily')),
            PopupMenuItem(value: CalendarView.week, child: Text('Weekly')),
            PopupMenuItem(value: CalendarView.month, child: Text('Monthly')),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarArea(BuildContext context, List<Event> events,
      CalendarPageModel watchModel, CalendarPageModel readModel) {
    return Scaffold(
      body: SfCalendar(
        showDatePickerButton: true,
        cellBorderColor: Colors.grey,
        controller: watchModel.calendarController,
        view: watchModel.calendarView,
        dataSource: EventDataSource(events),
        allowDragAndDrop: true,
        dragAndDropSettings: const DragAndDropSettings(
          showTimeIndicator: true,
          indicatorTimeFormat: 'h:mm a',
        ),
        onTap: (details) {
          if ((details.appointments ?? []).isNotEmpty) {
            final event = details.appointments!.first;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventPage(event: event)),
            );
          }
        },
        onDragEnd: (details) {
          final event = details.appointment as Event;
          final newStart = details.droppingTime!;
          final newEnd =
              newStart.add(event.endTime.difference(event.startTime));

          repository.insertEvent(Event(
            id: event.id,
            title: event.title,
            colorValue: event.colorValue,
            startTime: newStart,
            endTime: newEnd,
          ));
        },
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          ModalBottomSheetRoute(
            builder: (_) => const NewItemModalsheet(),
            isScrollControlled: true,
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

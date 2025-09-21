import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld_2025/backend/event_data_source.dart';
import 'package:helloworld_2025/backend/user.dart';
import 'package:helloworld_2025/frontend/components/new_item_modalsheet.dart';
import 'package:helloworld_2025/frontend/home_page/calendar_page_model.dart';
import 'package:helloworld_2025/frontend/event_page/event_page.dart';
import 'package:helloworld_2025/global/global_functions.dart';
import 'package:helloworld_2025/global/global_variables.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/task_list/task_list.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late EventDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = EventDataSource(repository.getEvents());

    // Listen to ObjectBox stream and update datasource
    repository.streamEvents().listen((events) {
      _dataSource.updateEvents(events);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarPageModel(repository),
      builder: (context, child) {
        final readModel = context.read<CalendarPageModel>();
        final watchModel = context.watch<CalendarPageModel>();

        return Scaffold(
          appBar: _buildAppBar(context, readModel, watchModel),
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
          body: MultiSplitViewTheme(
            data: MultiSplitViewThemeData(
              dividerThickness: 20,
            ),
            child: MultiSplitView(
              axis: Axis.vertical,
              resizable: true,
              dividerBuilder:
                  (axis, index, resizable, dragging, highlighted, themeData) {
                return MouseRegion(
                  cursor: SystemMouseCursors.resizeRow,
                  child: Container(
                    color: Colors.grey.shade500,
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
                          borderRadius: BorderRadius.circular(2),
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
                  builder: (context, area) =>
                      _buildCalendarArea(context, watchModel, readModel),
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
  }

  Widget _buildCalendarArea(BuildContext context, CalendarPageModel watchModel,
      CalendarPageModel readModel) {
    return Scaffold(
      body: SfCalendar(
        showDatePickerButton: true,
        cellBorderColor: Colors.grey,
        controller: watchModel.calendarController,
        view: watchModel.calendarView,
        dataSource: _dataSource, // ✅ persistent datasource
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
          } else if (details.date != null) {
            final event = Event(
              title: 'Untitled Event',
              colorValue: Colors.blue.value,
              startTime: details.date!,
              endTime: details.date!.add(const Duration(hours: 1)),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EventPage(
                        isNew: true,
                        event: event,
                      )),
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
    );
  }

  AppBar _buildAppBar(BuildContext context, CalendarPageModel readModel,
      CalendarPageModel watchModel) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: InkWell(
        onLongPress: () {
          repository.deleteAllEvents();
          repository.deleteAllTasks();
          generateAndSaveWeeklySchedule();
        },
        child: Text(
          'Flexendar',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
}

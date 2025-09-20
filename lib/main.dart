import 'package:flutter/material.dart';
import 'package:helloworld_2025/event.dart';
import 'package:helloworld_2025/event_data_source.dart';
import 'package:helloworld_2025/global_variables.dart';
import 'package:helloworld_2025/main_initializations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Future<void> main() async {
  await initMain();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: repository.streamEvents(),
        builder: (context, snapshot) {
          final events = snapshot.data ?? repository.getEvents();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: SfCalendar(
              view: CalendarView.week,
              dataSource: EventDataSource(events),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final newEvent = await showDialog<Event>(
                  context: context,
                  builder: (context) {
                    final titleController = TextEditingController();
                    DateTime start = DateTime.now();
                    DateTime end = start.add(const Duration(hours: 1));
                    return AlertDialog(
                      title: const Text("New Event"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: titleController,
                            decoration:
                                const InputDecoration(labelText: "Title"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: start,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                start = DateTime(picked.year, picked.month,
                                    picked.day, start.hour);
                                end = start.add(const Duration(hours: 1));
                              }
                            },
                            child: const Text("Pick Date"),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isEmpty) return;
                            Navigator.pop(
                              context,
                              Event(
                                title: titleController.text,
                                startTime: start,
                                endTime: end,
                                colorValue: Colors.blue.value,
                              ),
                            );
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    );
                  },
                );

                if (newEvent != null) {
                  repository.insertEvent(newEvent);
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}

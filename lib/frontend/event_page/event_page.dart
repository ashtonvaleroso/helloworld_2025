import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:provider/provider.dart';
import 'event_page_model.dart';

class EventPage extends StatelessWidget {
  final Event? event;
  const EventPage({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventPageModel(event),
      builder: (context, child) {
        final model = Provider.of<EventPageModel>(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(event?.title != null ? 'Edit Event' : 'New Event'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => model.saveEvent(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: model.titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Start Time'),
                  subtitle: Text(model.startTime.toString()),
                  onTap: () => model.pickStartDateTime(context),
                ),
                ListTile(
                  title: const Text('End Time'),
                  subtitle: Text(model.endTime.toString()),
                  onTap: () => model.pickEndDateTime(context),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('All Day'),
                  value: model.isAllDay,
                  onChanged: model.setAllDay,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Color'),
                  trailing: CircleAvatar(backgroundColor: model.color),
                  onTap: () => model.pickColor(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

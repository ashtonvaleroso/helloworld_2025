import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:provider/provider.dart';
import 'event_page_model.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {
  final Event? event;
  const EventPage({super.key, this.event});

  String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  Widget buildDateTimePicker({
    required BuildContext context,
    required String label,
    required DateTime dateTime,
    required VoidCallback onPickDate,
    required VoidCallback onPickTime,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onPickDate,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(formatDate(dateTime)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: onPickTime,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(formatTime(dateTime)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventPageModel(event),
      child: Consumer<EventPageModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(event != null ? 'Edit Event' : 'New Event'),
              centerTitle: true,
              actions: [
                if (event != null)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') model.deleteEvent(context);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
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
                  buildDateTimePicker(
                    context: context,
                    label: 'Start Time',
                    dateTime: model.startTime,
                    onPickDate: () => model.pickStartDate(context),
                    onPickTime: () => model.pickStartTime(context),
                  ),
                  const SizedBox(height: 16),
                  buildDateTimePicker(
                    context: context,
                    label: 'End Time',
                    dateTime: model.endTime,
                    onPickDate: () => model.pickEndDate(context),
                    onPickTime: () => model.pickEndTime(context),
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
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Event'),
                    onPressed: () => model.saveEvent(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

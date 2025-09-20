import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox/event.dart';

class NewEventDialog extends StatelessWidget {
  const NewEventDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
            decoration: const InputDecoration(labelText: "Title"),
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
                start =
                    DateTime(picked.year, picked.month, picked.day, start.hour);
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
  }
}

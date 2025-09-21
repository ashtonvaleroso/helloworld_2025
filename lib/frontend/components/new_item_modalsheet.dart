import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld_2025/frontend/dialogs/task_dialog.dart';
import 'package:helloworld_2025/frontend/event_page/event_page.dart';

class NewItemModalsheet extends StatelessWidget {
  const NewItemModalsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              DialogRoute(
                context: context,
                builder: (context) => TaskDialog(),
              ),
            ),
            label: Text(
              'New Task',
              style: GoogleFonts.inter(
                fontSize: 20,
              ),
            ),
            icon: Icon(Icons.task),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(),
              ),
            ),
            label: Text(
              'New Event',
              style: GoogleFonts.inter(
                fontSize: 20,
              ),
            ),
            icon: Icon(
              Icons.event,
              color: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(),
              ),
            ),
            label: Text(
              'Schedule Tasks',
              style: GoogleFonts.inter(
                fontSize: 20,
              ),
            ),
            icon: Icon(
              Icons.schedule,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.push(
                context,
                DialogRoute(
                  context: context,
                  builder: (context) => TaskDialog(),
                ),
              ),
              child: Text(
                'New Task',
                style: GoogleFonts.inter(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPage(),
                ),
              ),
              child: Text(
                'New Event',
                style: GoogleFonts.inter(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

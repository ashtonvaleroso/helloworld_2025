import 'package:flutter/material.dart';

class NewItemModalsheet extends StatelessWidget {
  const NewItemModalsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Cancel',
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}

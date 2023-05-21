import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/notes_model.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
  Colors.purpleAccent,
  Colors.greenAccent.shade400,
  Colors.cyanAccent,
];

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMMMd().format(note.createdTime);
    Random random = Random();
    Color bg = _lightColors[random.nextInt(8)];

    return Card(
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 10,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(
                top: 5,
                right: 8,
                left: 8,
                bottom: 0,
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              subtitle: Text(
                note.description,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      /*Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              note.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),*/
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}

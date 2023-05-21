import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/notes_database.dart';
import '../model/notes_model.dart';
import '../widget/custom_icon_button.dart';
import 'edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconBtn(
                      color: Theme.of(context).colorScheme.background,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                    ),
                    RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: 'Notes',
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: 'Rec',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ])),
                    CustomIconBtn(
                      color: Theme.of(context).colorScheme.background,
                      onPressed: () async {
                        if (isLoading) return;

                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEditNotePage(note: note),
                        ));

                        refreshNote();
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat.yMMMd().format(note.createdTime),
                              ),
                              const SizedBox(height: 50),
                              Text(
                                note.description,
                                style: const TextStyle(fontSize: 22),
                              )
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          tooltip: "delete",
          child: const Icon(
            Icons.delete,
            size: 30,
          ),
          onPressed: () async {
            await NotesDatabase.instance.delete(widget.noteId);

            Navigator.of(context).pop();
          },
        ));
  }

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}

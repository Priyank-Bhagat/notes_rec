import 'package:flutter/material.dart';

import '../db/notes_database.dart';
import '../model/notes_model.dart';
import '../widget/custom_icon_button.dart';
import '../widget/note_form_widget.dart';


class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context)  {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17 , horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomIconBtn(
                      color: Theme.of(context).colorScheme.background,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Text(
                      "NotesRec",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: NoteFormWidget(
                      isImportant: isImportant,
                      number: number,
                      title: title,
                      description: description,
                      onChangedImportant: (isImportant) =>
                          setState(() => this.isImportant = isImportant),
                      onChangedNumber: (number) => setState(() => this.number = number),
                      onChangedTitle: (title) => setState(() => this.title = title),
                      onChangedDescription: (description) =>
                          setState(() => this.description = description),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      floatingActionButton: buildFloatingButton(),
      );}


  Widget buildFloatingButton(){
    final isFormValid = title.isNotEmpty && description.isNotEmpty;
    return FloatingActionButton.extended(
      disabledElevation: 2,
      onPressed: addOrUpdateNote,
      label: Text("Save"),
      icon: Icon(Icons.save),
    );
  }



  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}

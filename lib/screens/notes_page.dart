import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../db/notes_database.dart';
import '../model/model_theme.dart';
import '../model/notes_model.dart';
import '../widget/custom_icon_button.dart';
import '../widget/note_card_widget.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';



class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Consumer<ThemeModel>(builder: (context, ThemeModel themeNotifier, child){
    return Scaffold(
      /*appBar: AppBar(
        centerTitle: true,
        elevation: 0,
          backgroundColor: Colors.transparent,
        leading: CustomIconBtn(
            color: Theme.of(context).colorScheme.background,
            onPressed: () {
              themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
            },
            icon: Icon(themeNotifier.isDark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded)),
        title:  Text(
          "NotesRec",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CustomIconBtn(
              color: Theme.of(context).colorScheme.background,
              onPressed: () {},
              icon: Icon(Icons.list))

        ],
      ),*/
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17 , horizontal: 16),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconBtn(
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          themeNotifier.isDark
                              ? themeNotifier.isDark = false
                              : themeNotifier.isDark = true;
                        },
                        icon: Icon(themeNotifier.isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded)),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Notes' ,style: TextStyle(
                          color: Colors.cyan,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                        TextSpan(text: 'Rec', style: TextStyle(
                          color: Colors.orange,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                      ]
                    )),
                    CustomIconBtn(
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {},
                        icon: Icon(Icons.list)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : notes.isEmpty
                      ? Text(
                    'No notes, create some',
                    style: TextStyle( fontSize: 22),
                  )
                      : buildNotes(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Note",
        child: Icon(
          Icons.note_add_sharp,
          size: 30,
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );

          refreshNotes();
        },
      ),
    );
  });

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}

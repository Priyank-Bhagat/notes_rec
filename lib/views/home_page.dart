import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../db/notes_database.dart';
import '../model/model_theme.dart';
import '../model/notes_model.dart';
import '../widget/custom_icon_button.dart';
import '../widget/note_card_widget.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  bool gridView = true;
  int gridInt = 2;

  @override
  Widget build(BuildContext context) =>
      Consumer<ThemeModel>(builder: (context, ThemeModel themeNotifier, child) {
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
                            themeNotifier.isDark
                                ? themeNotifier.isDark = false
                                : themeNotifier.isDark = true;
                          },
                          icon: Icon(themeNotifier.isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded)),
                      Hero(
                        tag: 'logo',
                        child: RichText(
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
                      ),
                      CustomIconBtn(
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          setState(() {
                            if (gridView == true) {
                              gridView = false;
                              gridInt = 4;
                            } else if (gridView == false) {
                              gridInt = 2;
                              gridView = true;
                            }
                          });
                        },
                        icon: Icon(gridInt == 4 ? Icons.list : Icons.grid_on),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : notes.isEmpty
                              ? const Text(
                                  'No notes, create some',
                                  style: TextStyle(fontSize: 22),
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
            child: const Icon(
              Icons.note_add_sharp,
              size: 30,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddEditNotePage()),
              );

              refreshNotes();
            },
          ),
        );
      });

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(gridInt),
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

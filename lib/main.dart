import 'package:flutter/material.dart';
import 'package:note_rec/model/model_theme.dart';
import 'package:note_rec/screens/notes_page.dart';
import 'package:note_rec/utils/themes.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ThemeModel(),
    child: Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child){
        return  MaterialApp(
        theme: themeNotifier.isDark ? Themes().dartTheme : Themes().lightTheme,
        darkTheme: Themes().dartTheme,
        themeMode: ThemeMode.system,
        home: NotesPage(),
        );
      },
    ),
    );
  }
}

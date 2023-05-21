import 'dart:async';
import 'package:flutter/material.dart';
import 'package:note_rec/model/model_theme.dart';
import 'package:note_rec/utils/themes.dart';
import 'package:flutter/services.dart';
import 'package:note_rec/views/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
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
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            theme:
                themeNotifier.isDark ? Themes().dartTheme : Themes().lightTheme,
            darkTheme: Themes().dartTheme,
            themeMode: ThemeMode.system,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'logo',
        child: RichText(
            text: const TextSpan(children: [
          TextSpan(
              text: 'Notes',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              )),
          TextSpan(
              text: 'Rec',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              )),
        ])),
      ),
    );
  }
}

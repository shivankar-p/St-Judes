import 'package:first/screens/Language.dart';
import 'package:first/widgets/record.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/mainScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future notif;
  int loginstate = 1;

  getState() async {
    var prefs = await SharedPreferences.getInstance();
    // loginstate = prefs.getInt('loginstate') ?? 0;
    return loginstate;
  }

  @override
  void initState() {
    super.initState();

    notif = getState();
  }

  showScreen() {
    if (loginstate == 0) {
      return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: Language());
    } else {
      return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: Mainscreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: notif,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('There is an error ${snapshot.error.toString()}');
          return Text('Something went wrong');
        } else if (snapshot.hasData) {
          return showScreen();
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}

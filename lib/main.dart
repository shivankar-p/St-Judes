import 'package:first/screens/Language.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/mainScreen.dart';
import 'package:provider/provider.dart';
import 'LocaleProvider.dart';
import 'l10n/l10n.dart';

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
  late String uid;

  getState() async {
    var prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('loginstate') ?? '';
    return uid;
  }

  @override
  void initState() {
    super.initState();

    notif = getState();
  }

  showScreen(LocaleProvider provider) {
    if (uid.isEmpty) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          locale: provider.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: Mainscreen());
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          locale: provider.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.orange, fontFamily: 'ProximaNovaRegular'),
          home: Mainscreen());
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return FutureBuilder(
          future: notif,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('There is an error ${snapshot.error.toString()}');
              return Text('Something went wrong');
            } else if (snapshot.hasData) {
              return showScreen(provider);
            } else {
              return Center(
                  child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)));
            }
          },
        );
      });
}

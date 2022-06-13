import 'package:first/screens/Language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first/screens/faq.dart';
import 'package:first/widgets/Counselling.dart';
import 'package:first/widgets/Raise_request.dart';
import 'package:first/widgets/requestHistory.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../LocaleProvider.dart';
import '../widgets/notifications.dart';

import '../widgets/overlay.dart';
import '../widgets/displayRequests.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/uidvalue.dart';

class Constants {
  static const String Language = 'Change Language';
  static const String Log = 'View Request Log';

  static const List<String> choices = <String>[Language, Log];
}

class LanguageList1 extends StatelessWidget {
  var languages = [
    ['English (default)', 'en'],
    ['தமிழ் (Tamil)', 'ta'],
    ['తెలుగు (Telugu)', 'te'],
    ['हिन्दी (Hindi)', 'hi'],
    ['മലയാളം (Malayalam)', 'ml'],
    ['বাংলা (Bengali)', 'bn']
  ];
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('uidToPhone/${UIDValue.uid}');

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return Center(
        child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            width: 230,
            child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: <Widget>[
                  ...languages.map((e) => Card(
                      child: ListTile(
                          title: Center(
                              child: Text(e[0],
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)))),
                          onTap: () async {
                            provider.setLocale(Locale(e[1]));
                            var prefs = await SharedPreferences.getInstance();
                            prefs.setString('locale', e[1]);
                            ref.child('language').set(e[1]);
                            Navigator.pop(context);
                          },
                          tileColor: Color.fromARGB(255, 255, 255, 255))))
                ])));
  }
}

class Mainscreen extends StatefulWidget {
  const Mainscreen({Key? key}) : super(key: key);

  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _selectedIndex = 0;
  int _appStateR = 0;
  int _appStateC = 0;
  String lang = 'en';

  Future getAppState() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _appStateC = prefs.getInt('counselling') ?? 0;
      _appStateR = prefs.getInt('request') ?? 0;
      lang = prefs.getString('locale') ?? 'en';
      provider.setLocale(Locale(lang));
      if (_appStateR > 1) _appStateR = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    getAppState();
  }

  void choiceAction(String choice) {
    if (choice == Constants.Language) {
      showDialog(
        context: context,
        builder: (_) => LanguageList1(),
      );
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => (History())));
    }
  }

  var provider;

  List<List<Widget>> screens = [
    [RaiseRequest(), Displayrequests()],
    [Counselling()],
    [Notifications()]
  ];

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        if (index == 0) {
          return screens[index][_appStateR];
        }
        return screens[index][0];
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }

  Widget displayScreen() {
    return Scaffold(
      appBar: AppBar(
        //St judes for life
        title: Text("St. Judes for Life",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'ProximaNovaRegular',
                fontSize: 22,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1)),
        elevation: 5,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (FAQ(context))));
                },
                child: Icon(
                  Icons.help,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => FunkyOverlay(),
                  );
                },
                child: Icon(
                  Icons.contact_page_sharp,
                  size: 26.0,
                ),
              )),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                //raise request
                icon: Icon(Icons.add_moderator),
                label: AppLocalizations.of(context)!.raisereq),
            BottomNavigationBarItem(
                //counselling
                icon: Icon(Icons.announcement),
                label: AppLocalizations.of(context)!.counselling),
            BottomNavigationBarItem(
                //notifications
                icon: Icon(Icons.notifications),
                label: AppLocalizations.of(context)!.notifications)
          ],
          onTap: (index) => {
                setState(() {
                  _selectedIndex = index;
                })
              }),
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LocaleProvider>(context);
    return displayScreen();
  }
}

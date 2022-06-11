import 'package:first/screens/faq.dart';
import 'package:first/widgets/Counselling.dart';
import 'package:first/widgets/Raise_request.dart';
import 'package:first/widgets/requestHistory.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/notifications.dart';

import '../widgets/overlay.dart';
import '../widgets/displayRequests.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Constants {
  static const String history = 'View Request History';
  static const String Language = 'Change Language';

  static const List<String> choices = <String>[Language, history];
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

  Future getAppState() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _appStateC = prefs.getInt('counselling') ?? 0;
      _appStateR = prefs.getInt('request') ?? 0;
      if (_appStateR > 1) _appStateR = 1;
    });
  }

  // void choiceAction(String choice) {
  //   if (choice == Constants.Profile) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return ProfilePage(widget.myController);
  //     }));
  //     print('Profile');
  //   } else if (choice == Constants.Language) {
  //     print('Language');
  //   } else if (choice == Constants.Logout) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  //       return UIDform();
  //     }));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getAppState();
  }

  void choiceAction(String choice) {
    if (choice == Constants.Language) {
      print('Language');
    } else {
      showDialog(
        context: context,
        builder: (_) => FunkyOverlay(),
      );
    }
  }

  List<List<Widget>> screens = [
    [RaiseRequest(), Displayrequests()],
    [Counselling()],
    [Notifications()]
  ];

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        if (index == 0) {
          return screens[index][1];
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
        title: Text("St Judes"),
        elevation: 5,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (FAQ())));
                },
                child: Icon(
                  Icons.help,
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
                icon: Icon(Icons.home), label: 'Raise Request'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Counselling'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications')
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
    return displayScreen();
  }
}

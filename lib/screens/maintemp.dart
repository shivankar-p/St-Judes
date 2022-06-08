import 'package:first/widgets/Counselling.dart';
import 'package:first/widgets/Raise_request.dart';
import 'package:first/widgets/requestWait.dart';
import 'package:flutter/material.dart';
import '../widgets/uploadWait.dart';
import '../widgets/upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/notifications.dart';

class LoggedInScreen extends StatefulWidget {
  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class Constants {
  static const String Logout = 'Logout';
  static const String Profile = 'Profile';
  static const String Language = 'Language';

  static const List<String> choices = <String>[Profile, Language, Logout];
}

class _LoggedInScreenState extends State<LoggedInScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showFab = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController.addListener(() {
      showFab = true;
      setState(() {});
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("St Judes"),
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          indicatorWeight: 5.0,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: <Widget>[
            Tab(
              text: "Requests",
            ),
            Tab(
              text: "Counselling",
            ),
            Tab(text: "Notifications")
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
          PopupMenuButton<String>(
            // onSelected: choiceAction,
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
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[RaiseRequest(), Counselling(), Notifications()],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.message,
                color: Colors.white,
              ),
              onPressed: () => print("open chats"),
            )
          : null,
    );
  }
}

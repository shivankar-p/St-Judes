import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Old {
  Widget icon;
  String date;
  String remarks;

  Old(this.date, this.icon, this.remarks);
}

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future notif;
  List<Old> olds = [];
  getValues() async {
    var prefs = await SharedPreferences.getInstance();
    final stringlistold = prefs.getStringList('old');

    if (stringlistold != null) {
      for (int i = 0; i < stringlistold.length; i += 3) {
        var date = stringlistold[i];
        var remarks = stringlistold[i + 1];
        Icon icon = stringlistold[i + 2] == '4'
            ? Icon(Icons.check_circle)
            : Icon(Icons.error);
        olds.add(Old(date, icon, remarks));
      }
    }
    return olds;
  }

  @override
  void initState() {
    super.initState();
    notif = getValues();
  }

  show() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
          child: Text("OLDER REQUESTS",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromARGB(255, 27, 63, 27),
                fontSize: 20,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1,
              )),
        ),
        Expanded(
            child: ListView(padding: const EdgeInsets.all(8), children: [
          ...List.from(olds.reversed).map((e) => Card(
              child: ListTile(
                  title: Text(e.date),
                  subtitle: Text(e.remarks),
                  leading: CircleAvatar(child: e.icon),
                  trailing: Icon(Icons.star))))
        ]))
      ],
    );
  }

  @override
  build(BuildContext context) {
    return MaterialApp(
      title: "Request History",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios_new),
              iconSize: 20.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text("Request History"),
          ),
          body: FutureBuilder(
            future: notif,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.hasData) {
                return show();
              } else {
                return Center(child: const CircularProgressIndicator());
              }
            },
          )),
    );
  }
}

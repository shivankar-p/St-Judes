import 'package:first/widgets/requestWait.dart';
import 'package:first/widgets/upload.dart';
import 'package:first/widgets/uploadWait.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Active {
  Widget icon;
  String date;
  String state;

  Active(this.date, this.icon, this.state);
}

class Old {
  Widget icon;
  String date;
  String remarks;

  Old(this.date, this.icon, this.remarks);
}

class Displayrequests extends StatefulWidget {
  const Displayrequests({Key? key}) : super(key: key);

  @override
  _DisplayrequestsState createState() => _DisplayrequestsState();
}

class _DisplayrequestsState extends State<Displayrequests> {
  DatabaseReference ref1 =
      FirebaseDatabase.instance.ref('activerequests/15000');
  DatabaseReference ref2 = FirebaseDatabase.instance.ref('requests/15000');

  late Future notif;
  List<Old> olds = [];
  Active active = Active('14-06-2022', Icon(Icons.pending_actions_rounded),
      'Request Raised. Waiting for approval.');

  int stateindex = 1;

  var _widgetList = [RequestWait(), Upload(), UploadWait()];

  fillActive(date, state) {
    setState(() {
      active.date = date;

      if (state == 1) {
        active.state = 'Request Raised. Waiting for approval.';
      } else if (state == 2) {
        active.state =
            'Request shortlisted. You can proceed to upload documents.';
      } else if (state == 3) {
        active.state =
            'Documents have been apploaded. Please wait till we verify them.';
      } else if (state == 4) {
        active.state = 'Request Approved. We ll contact you shortly';
      } else
        active.state = 'Request not approved';
    });
  }

  getValues() async {
    var prefs = await SharedPreferences.getInstance();
    final stringlistactive = prefs.getStringList('active');
    final stringlistold = prefs.getStringList('old');
    fillActive(stringlistactive![0], int.parse(stringlistactive[1]));

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
    stateindex = prefs.getInt('request') ?? 1;
    return stateindex;
  }

  @override
  void initState() {
    super.initState();
    notif = getValues();

    ref1.onValue.listen((event) {
      var value = event.snapshot.value as Map<dynamic, dynamic>;
      fillActive(value['date'], value['state']);
    });
  }

  Widget showScreen() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 30, left: 10),
              child: Text("ACTIVE REQUESTS",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(255, 27, 63, 27),
                    fontSize: 20,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ))),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                  child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    (_widgetList[stateindex - 1])));
                      },
                      title: Text(active.date),
                      subtitle: Text(active.state),
                      leading: CircleAvatar(
                          child: Icon(Icons.pending_actions_rounded)),
                      trailing: Icon(Icons.star)))),
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
        ]);
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

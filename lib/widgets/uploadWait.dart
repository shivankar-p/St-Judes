import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'upload.dart';
import 'Raise_request.dart';
import '../models/document.dart';

class UploadWait extends StatefulWidget {
  @override
  _UploadWaitState createState() => _UploadWaitState();
}

class _UploadWaitState extends State<UploadWait> {
  int _state = 1;

  DatabaseReference ref = FirebaseDatabase.instance.ref('activerequests/15000');

  late String statusdate, statusremarks;
  late int statusstate;

  getUploadData() async {
    var event = await ref.child('docs').once();
    var data = event.snapshot.value as Map<dynamic, dynamic>;
    var map = data.keys;
    List<String> stringlist = [];
    // for (int i = 0; i < data.length; i++) {
    //   if (data[i] != null) {
    //     stringlist.add(i.toString());
    //     stringlist.add(data[i]['state'].toString());
    //   }
    // }
    map.forEach((doc) {
      stringlist.add(dockeys.indexOf(doc).toString());
      stringlist.add(data[doc]['state'].toString());
    });
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', stringlist);
  }

  getStatusData() async {
    var event = await ref.child('close_remarks').once();
    var data = event.snapshot.value as String;

    event = await ref.once();
    var data1 = event.snapshot.value as Map<dynamic, dynamic>;

    statusremarks = data;
    statusstate = data1['state'];
    statusdate = data1['date'];
  }

  checkValue() async {
    var event = await ref.child('state').once();
    var value = event.snapshot.value as int;
    setState(() {
      _state = value;
    });
    if (_state == 2) {
      getUploadData();
    } else if (_state == 4 || _state == -1) {
      getStatusData();
    }
  }

  @override
  void initState() {
    super.initState();

    checkValue();

    ref.child('state').onValue.listen((event) {
      var value = event.snapshot.value as int;
      setState(() {
        _state = value;
      });
      if (_state == 2) {
        getUploadData();
      } else if (_state == 4 || _state == -1) {
        getStatusData();
      }
    });
  }

  changeState(int i) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('request', i);

    if (i == 0) {
      var stringlist = prefs.getStringList('old');
      var list = [statusdate, statusremarks, statusstate.toString()];

      if (stringlist != null) {
        stringlist.addAll(list);
        await prefs.setStringList('old', stringlist);
      } else
        await prefs.setStringList('old', list);
    }
  }

  Widget displayScreen() {
    if (_state == 1) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //const CircularProgressIndicator(),
        Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/safe.png')))),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(15),
          child: Container(
              child: Center(
                  child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.safe,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(109, 109, 109, 1),
                  fontFamily: 'ProximaNovaRegular',
                  fontSize: 22,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ))),
        ),
      ]);
    } else if (_state == 3) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 320,
            height: 320,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/upload.png')))),
        SizedBox(height: 20),
        Container(
            child: Center(
                child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            AppLocalizations.of(context)!.uploaded,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(109, 109, 109, 1),
                fontFamily: 'ProximaNovaRegular',
                fontSize: 22,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        )))
      ]);
    } else if (_state == 2) {
      return Center(
          child: Column(children: [
        SizedBox(height: 30),
        Container(
            width: 310,
            height: 310,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/reupload.png')))),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(AppLocalizations.of(context)!.reuploaded,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(109, 109, 109, 1),
                  fontFamily: 'ProximaNovaRegular',
                  fontSize: 22,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1)),
        ),
        SizedBox(height: 40),
        ElevatedButton(
            child: Text(AppLocalizations.of(context)!.updocs,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'ProximaNovaRegular',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                )),
            onPressed: () {
              changeState(2);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => (Upload())));
            })
      ]));
    }
    return Center(
        child: Column(children: [
      SizedBox(height: 15),
      Container(
          width: 310,
          height: 310,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/congrats.png')))),
      Padding(
        padding: EdgeInsets.all(15),
        child: Text(AppLocalizations.of(context)!.verified,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(109, 109, 109, 1),
                fontFamily: 'ProximaNovaRegular',
                fontSize: 22,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1)),
      ),
      SizedBox(height: 20),
      ElevatedButton(
          child: Text(AppLocalizations.of(context)!.homescreen,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'ProximaNovaRegular',
                fontSize: 20,
                fontWeight: FontWeight.normal,
              )),
          onPressed: () {
            changeState(0);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => (RaiseRequest())));
          })
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return displayScreen();
  }
}

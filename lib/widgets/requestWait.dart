import 'package:first/widgets/Raise_request.dart';
import 'package:first/widgets/uploadWait.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document.dart';

class RequestWait extends StatefulWidget {
  @override
  _RequestWaitState createState() => _RequestWaitState();
}

class _RequestWaitState extends State<RequestWait> {
  int _state = 1;
  DatabaseReference ref = FirebaseDatabase.instance.ref('activerequests/15000');

  late String rejectdate, rejectremarks;

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

  getRejectData() async {
    var event = await ref.child('close_remarks').once();
    var data = event.snapshot.value as String;

    event = await ref.once();
    var data1 = event.snapshot.value as Map<dynamic, dynamic>;

    rejectremarks = data;
    rejectdate = data1['date'];
  }

  checkValue() async {
    var event = await ref.once();
    var value = event.snapshot.value as Map<dynamic, dynamic>;
    setState(() {
      _state = value['state'];
    });
    if (_state == 2) {
      getUploadData();
    } else if (_state == -1) {
      getRejectData();
    }
  }

  @override
  void initState() {
    super.initState();

    checkValue();

    ref.onValue.listen((event) {
      var value = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _state = value['state'];
      });
      if (_state == 2) {
        getUploadData();
      } else if (_state == -1) {
        getRejectData();
      }
    });
  }

  changeState(int i) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('request', i);

    if (i == 0) {
      var stringlist = prefs.getStringList('old');
      var list = [rejectdate, rejectremarks, '-1'];

      if (stringlist != null) {
        stringlist.addAll(list);
        await prefs.setStringList('old', stringlist);
      } else
        await prefs.setStringList('old', list);
    }
  }

  Widget displayScreen() {
    if (_state == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Processing.png')))),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
                child: Center(
                    child: Text(
              AppLocalizations.of(context)!.reqwait,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(109, 109, 109, 1),
                  fontFamily: 'ProximaNovaRegular',
                  fontSize: 22,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ))),
          ),
        ],
      );
    } else if (_state == 2) {
      //2
      return Center(
          child: Column(children: [
        SizedBox(height: 30),
        Container(
            width: 320,
            height: 320,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/Approved.png')))),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(AppLocalizations.of(context)!.reqapp,
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
            child: Text(AppLocalizations.of(context)!.load,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'ProximaNovaRegular',
                  fontSize: 20,
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
      SizedBox(height: 30),
      Container(
          width: 300,
          height: 300,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Rejected.png')))),
      Padding(
        padding: EdgeInsets.all(15),
        child: Text(AppLocalizations.of(context)!.reqrej,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(109, 109, 109, 1),
                fontFamily: 'ProximaNovaRegular',
                fontSize: 22,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1)),
      ),
      SizedBox(height: 25),
      ElevatedButton(
          child: Text(AppLocalizations.of(context)!.homescreen,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'ProximaNovaRegular',
                fontSize: 20,
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

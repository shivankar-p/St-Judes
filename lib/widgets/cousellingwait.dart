import 'package:first/models/uidvalue.dart';
import 'package:first/widgets/Raise_request.dart';
import 'package:first/widgets/uploadWait.dart';
import 'package:first/widgets/videocall.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document.dart';

class Cwait extends StatefulWidget {
  @override
  _CwaitState createState() => _CwaitState();
}

class _CwaitState extends State<Cwait> {
  int _state = 1;
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('counselling/${UIDValue.uid}');

  @override
  void initState() {
    super.initState();

    ref.onValue.listen((event) {
      var value = event.snapshot.value as int;
      setState(() {
        _state = value;
      });
    });
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
              'Your request for a online counseliing has beeb raised. Further details will be notified once it is approved',
              //AppLocalizations.of(context)!.reqwait,
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
    } else {
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
          child: Text('Your appointment timings are conveyed to you.',
              //,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (Videocall())));
            })
      ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayScreen();
  }
}

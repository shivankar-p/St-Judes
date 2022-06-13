import 'package:first/models/uidvalue.dart';
import 'package:first/widgets/videocall.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class Cwait extends StatefulWidget {
  @override
  _CwaitState createState() => _CwaitState();
}

class _CwaitState extends State<Cwait> {
  int _state = 1;
  String date = 'DATE1';
  String time = 'TIME1';
  String link = 'LINK';
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('counselling/${UIDValue.uid}');

  @override
  void initState() {
    super.initState();

    ref.onValue.listen((event) {
      var value = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _state = value['state'];
      });
      if (_state == 2) {
        date = value['date'];
        time = value['time'];
        link = value['link'];
      }
    });
  }

  Widget displayScreen() {
    if (_state == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/cwait.jpeg')))),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
                child: Center(
                    child: Text(
              'Your request for a online counselling has been raised. Further details will be notified once it is approved.',
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
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 320,
            height: 320,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/Approved.png')))),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
              'Your appointent has been made. Please join the meet at your scheduled time.',
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
        Padding(
          padding: EdgeInsets.all(15),
          child: Text('Date: $date\n\nTime: $time',
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
        SizedBox(height: 20),
        ElevatedButton(
            child: Text('Join Meet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'ProximaNovaRegular',
                  fontSize: 20,
                )),
            onPressed: () async {
              Uri _url = Uri.parse(link);
              if (!await launchUrl(_url)) throw 'Could not launch $_url';
            })
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayScreen();
  }
}

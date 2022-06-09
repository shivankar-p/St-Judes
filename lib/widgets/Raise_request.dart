import 'package:first/widgets/displayRequests.dart';
import 'package:first/widgets/requestHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'requestWait.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RaiseRequest extends StatelessWidget {
  DatabaseReference ref1 =
      FirebaseDatabase.instance.ref('activerequests/15000');
  DatabaseReference ref2 =
      FirebaseDatabase.instance.ref('uidToPhone/15000/request');

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Stack(children: <Widget>[
            Positioned(
                top: 320 * (constraints.maxHeight / 800),
                left: 50 * (constraints.maxWidth / 360),
                child: Container(
                    width: 267,
                    height: 205,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/financial.png'))))),
            Positioned(
                top: 100 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                child: const Text('Raise a\nRequest',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(245, 130, 32, 1),
                        fontFamily: 'RobotoSerif-SemiBold',
                        fontSize: 40,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1))),
            Positioned(
                top: 75 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                child: const Text(
                  'Need financial help?',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(245, 129, 45, 1),
                      fontFamily: 'RobotoSerif-SemiBold',
                      fontSize: 18,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            Positioned(
                top: 215 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                right: 25 * (constraints.maxWidth / 360),
                child: const Text(
                  'Dont worry! Once you raise a request, our officials shall contact you to furthur understand your problem and requirement.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(109, 109, 109, 1),
                      fontFamily: 'RobotoSerif-SemiBold',
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            Positioned(
                top: 620 * (constraints.maxHeight / 800),
                left: 80 * (constraints.maxWidth / 360),
                child: Column(children: [
                  SizedBox(
                      width: 200,
                      height: 54,
                      child: ElevatedButton(
                        child: Text(
                          'Raise Request',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'RobotoSerif-Regular',
                              fontSize: 24,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                        onPressed: () {
                          changeState();
                          ref1.set({
                            'date':
                                DateFormat('dd-MM-yyyy').format(DateTime.now()),
                            'state': 1,
                            'language': 'english',
                            'logs': {
                              'amount': 0,
                              'category': '',
                              'description': '',
                              'remarks': ''
                            }
                          });

                          ref2.set(1);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (Displayrequests())));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(245, 130, 32, 1),
                            padding: EdgeInsets.all(10)),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => (History())));
                    },
                    child: const Text('Or view request history'),
                  )
                ])),
          ]));
    }));
  }

  changeState() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'active', [DateFormat('dd-MM-yyyy').format(DateTime.now()), '1']);
    await prefs.setInt('request', 1);
  }
}

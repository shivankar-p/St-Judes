import 'package:first/widgets/cousellingwait.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/uidvalue.dart';

class Counselling extends StatelessWidget {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('counselling/${UIDValue.uid}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Positioned(
                top: 340 * (constraints.maxHeight / 800),
                left: 50 * (constraints.maxWidth / 360),
                child: Container(
                    width: 267,
                    height: 205,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/Image21.png'))))),
            Positioned(
                top: 100 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                child: Text(
                    //Apply for counselling
                    AppLocalizations.of(context)!.applyfor +
                        '\n' +
                        AppLocalizations.of(context)!.incoun,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(245, 130, 32, 1),
                        fontFamily: 'ProximaNovaRegular',
                        fontSize: 40,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1))),
            Positioned(
                top: 70 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                child: Text(
                  //need some guidance
                  AppLocalizations.of(context)!.need,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(245, 129, 45, 1),
                      fontFamily: 'ProximaNovaSemibold',
                      fontSize: 18,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            Positioned(
                top: 220 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                right: 25 * (constraints.maxWidth / 360),
                child: Text(
                  //were there for you!
                  AppLocalizations.of(context)!.countext,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(109, 109, 109, 1),
                      fontFamily: 'ProximaNovaRegular',
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            Positioned(
              top: 640 * (constraints.maxHeight / 800),
              //left: 80 * (constraints.maxWidth / 360),
              child: SizedBox(
                  width: 200,
                  height: 54,
                  child: ElevatedButton(
                    child: Text(
                      //Get Enrolled
                      AppLocalizations.of(context)!.enrol,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'ProximaNovaRegular',
                          fontSize: 26,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                    onPressed: () {
                      ref.set({'state': 1, 'date': '', 'time': '', 'link': ''});
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => (Cwait())));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(245, 130, 32, 1),
                        padding: EdgeInsets.all(10)),
                  )),
            ),
          ]));
    }));
  }
}

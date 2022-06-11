import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Counselling extends StatelessWidget {
  DatabaseReference ref = FirebaseDatabase.instance.ref('counselling/15000');

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
                top: 335 * (constraints.maxHeight / 800),
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
                    AppLocalizations.of(context)!.applyfor +
                        '\n' +
                        AppLocalizations.of(context)!.incoun,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(245, 130, 32, 1),
                        fontFamily: 'RobotoSerif-SemiBold',
                        fontSize: 40,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1))),
            Positioned(
                top: 65 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                child: Text(
                  AppLocalizations.of(context)!.need,
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
                top: 225 * (constraints.maxHeight / 800),
                left: 25 * (constraints.maxWidth / 360),
                right: 25 * (constraints.maxWidth / 360),
                child: Text(
                  AppLocalizations.of(context)!.countext,
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
              top: 630 * (constraints.maxHeight / 800),
              //left: 80 * (constraints.maxWidth / 360),
              child: SizedBox(
                  width: 200,
                  height: 54,
                  child: ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.enrol,
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
                      // var newref = ref1.push();
                      // newref.set({'state': 1, 'language': 'english'});

                      // ref2.set(1);

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => (RequestWait())));
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

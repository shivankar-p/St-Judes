import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

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
          child: Stack(children: <Widget>[
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
                child: Text('Apply for\nCounselling',
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
                child: Text(
                  'Need some guidance?',
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
                child: Text(
                  'We’re there for you! On applying for counselling our officials will help you out with your much required career and life counselling.',
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
              child: SizedBox(
                  width: 200,
                  height: 54,
                  child: ElevatedButton(
                    child: Text(
                      'Get Enrolled',
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

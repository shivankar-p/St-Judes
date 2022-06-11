import 'package:first/widgets/displayRequests.dart';
import 'package:first/widgets/record.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RaiseRequest extends StatelessWidget {
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
                          showDialog(
                              context: context,
                              builder: (_) => RequestOptions(),
                              useRootNavigator: false);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(245, 130, 32, 1),
                            padding: EdgeInsets.all(10)),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     textStyle: const TextStyle(fontSize: 16),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => (History())));
                  //   },
                  //   child: const Text('Or view request history'),
                  // )
                ])),
          ]));
    }));
  }
}

class RequestOptions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RequestOptionsState();
}

class RequestOptionsState extends State<RequestOptions>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  DatabaseReference ref1 =
      FirebaseDatabase.instance.ref('activerequests/15000');
  UploadTask? task;

  changeState() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'active', [DateFormat('dd-MM-yyyy').format(DateTime.now()), '1']);
    await prefs.setInt('request', 1);
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  List<String> _languages = [
    'English (default)',
    'தமிழ் (Tamil)',
    'తెలుగు (Telugu)',
    'हिन्दी (Hindi)',
    'മലയാളം (Malayalam)',
    'বাংলা (Bengali)'
  ];

  var _locales = ['en', 'ta', 'te', 'hi', 'ml', 'bl'];

  String _path = 'foo.mp4';

  Future uploadFile() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + '/$_path';
    final file = File(tempPath);

    var ref = FirebaseStorage.instance.ref().child('files/$_path');
    setState(() {
      task = ref.putFile(file);
    });

    final snapshot = await task!.whenComplete(() {});
    var downloadUrl = await ref.getDownloadURL();

    ref1.child('voice').set(downloadUrl);

    setState(() {
      task = null;
    });
  }

  String _chosenValue = 'English (default)';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: SizedBox(
                height: 400,
                width: 350,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(children: [
                      Text(
                          'Choose Language of Communication. Futher steps will be taken in that language only.'),
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        value: _chosenValue,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: _languages.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Please choose a langauage",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value!;
                          });
                        },
                      ),
                      Text(
                          'Optionally please record any additional information you want to provide'),
                      Record(_path),
                      ElevatedButton(
                          child: Text('Submit Request'),
                          onPressed: () {
                            changeState();
                            ref1.set({
                              'date': DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now()),
                              'state': 1,
                              'language':
                                  _locales[_languages.indexOf(_chosenValue)],
                              'logs': {
                                'amount': 0,
                                'category': '',
                                'description': '',
                                'remarks': ''
                              }
                            });

                            uploadFile();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (Displayrequests())));
                          })
                    ]))),
          ),
        ),
      ),
    );
  }
}

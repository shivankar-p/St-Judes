import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  DatabaseReference ref = FirebaseDatabase.instance.ref('queries');

  static const NUMBER = '+918130494605';
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  late String _uid;

  getuid() async {
    var prefs = await SharedPreferences.getInstance();
    String _uid = prefs.getString('loginstate')!;
  }

  @override
  void initState() {
    super.initState();
    getuid();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  _callNumber() async {
    await FlutterPhoneDirectCaller.callNumber(NUMBER);
  }

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
                height: 630,
                width: 320,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17.0, vertical: 20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.contactus,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: 'Helvetica',
                                fontSize: 30,
                              )),
                          SizedBox(height: 15),
                          Text(AppLocalizations.of(context)!.qry,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: 'ProximaNovaRegular',
                                fontSize: 20,
                              )),
                          SizedBox(height: 20),
                          LayoutBuilder(builder: (context, constraints) {
                            return SizedBox(
                                height: 200,
                                child: TextField(
                                  controller: myController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter Query Here'),
                                  autocorrect: true,
                                  textAlignVertical: TextAlignVertical.top,
                                  expands: true,
                                  maxLines: null,
                                ));
                          }),
                          SizedBox(height: 30),
                          SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  child: Text(
                                      AppLocalizations.of(context)!.submit,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontFamily: 'ProximaNovaRegular',
                                          fontSize: 23,
                                          fontWeight: FontWeight.normal)),
                                  onPressed: () {
                                    if (myController.text.isNotEmpty) {
                                      var newref = ref.push();
                                      newref.set({
                                        'msg': myController.text,
                                        'uid': _uid,
                                        'date': DateFormat("dd MMMM yyyy")
                                            .format(DateTime.now()),
                                        'time': DateFormat("HH:mm:ss")
                                            .format(DateTime.now())
                                      });
                                    }
                                    Navigator.pop(context);
                                  })),
                          SizedBox(height: 25),
                          Text('OR',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: 'Helvetica',
                                fontSize: 25,
                              )),
                          SizedBox(height: 20),
                          Text(AppLocalizations.of(context)!.ring,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: 'ProximaNovaRegular',
                                fontSize: 23,
                              )),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: _callNumber,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.orange,
                                  size: 23.0,
                                ),
                                SizedBox(width: 10),
                                Text('Phone',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //color: Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: 'ProximaNovaRegular',
                                      fontSize: 25,
                                    )),
                              ],
                            ),
                          )
                        ]))),
          ),
        ),
      ),
    );
  }
}

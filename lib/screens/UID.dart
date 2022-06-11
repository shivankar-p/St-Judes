import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:first/screens/mainScreen.dart';
import '../widgets/HeroDialogue.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum MobileVerificationState {
  SHOW_UID_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class UIDform extends StatefulWidget {
  @override
  State<UIDform> createState() => _UIDform();
}

class _UIDform extends State<UIDform> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_UID_FORM_STATE;

  String _uidExists = '';
  String _otpValid = '';

  final _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance; //original code

  String phoneNum = "+911234567891";
  String testVerificationCode = "951597";

  late String verificationId;

  bool showLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //myController.dispose();
    super.dispose();
  }

  void _uidStatus(result) {
    setState(() {
      if (result == false) {
        //Invalid UID
        _uidExists = AppLocalizations.of(context)!.invaliduid;
        myController.text = '';
      } else {
        _uidExists = '';
      }
    });
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      print('Trying final auth');
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Mainscreen()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
        print('Caught some Exception ${e}');
        print(verificationId.length);
        print(verificationId);
        //Invalid OTP
        _otpValid = AppLocalizations.of(context)!.invalidotp;
      });
    }
  }

  getUIDFormWidget(context) {
    return Center(
        child: Hero(
      tag: "Transition1",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 220),
                  Center(
                      child: Text(_uidExists,
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 17, 0)))),
                  Center(
                    child: Material(
                        color: Colors.transparent,
                        //Enter UID
                        child: Text(AppLocalizations.of(context)!.uid,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'ProximaNovaRegular',
                              fontSize: 30,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ))),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Material(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: SizedBox(
                          width: 250,
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  //labelText: 'UID',
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none),
                              controller: myController,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      width: 110,
                      padding: const EdgeInsets.only(top: 40.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        //Submit
                        child: Text(AppLocalizations.of(context)!.submit,
                            style: TextStyle(
                                fontFamily: 'ProximaNovaRegular',
                                fontSize: 17,
                                color: Color.fromARGB(255, 255, 255, 255))),
                        onPressed: () async {
                          DatabaseReference _testRef = FirebaseDatabase.instance
                              .ref(
                                  'uidToPhone/' + myController.text + '/phone');
                          _testRef.onValue.listen((DatabaseEvent event) async {
                            final data = event.snapshot.value;
                            _uidStatus(event.snapshot.exists);
                            print(myController.text);
                            print(data.toString());
                            if (event.snapshot.exists) {
                              /* setState(() {
                              showLoading = true;
                            });
                            await _auth.verifyPhoneNumber(
                              phoneNumber: data.toString(),
                              verificationCompleted:
                                  (PhoneAuthCredential) async {
                                setState(() {
                                  showLoading = false;
                                });
                              },
                              verificationFailed: (verificationFailed) async {
                                setState(() {
                                  _otpValid = 'Invalid Otp. Please try again!';
                                  showLoading = false;
                                  print('updated otpstatus');
                                });
                              },
                              codeSent: (verificationId, resendingToken) async {
                                setState(() {
                                  showLoading = false;
                                  currentState = MobileVerificationState
                                      .SHOW_OTP_FORM_STATE;
                                  this.verificationId = verificationId;
                                  print('In verification state');
                                });
                              },
                              codeAutoRetrievalTimeout:
                                  (verificationId) async {},
                            ); */ //original code

                              /*dummy code*/
                              if (data.toString() == "+918105715824")
                                setState(() {
                                  currentState = MobileVerificationState
                                      .SHOW_OTP_FORM_STATE;
                                });
                            }
                            /*dummy code ends*/
                          });
                        },
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  getOTPFormWidget(context) {
    return Center(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 150),
                  Center(
                      child: Text(_otpValid,
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                  /* TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter your OTP',
                      labelText: 'OTP',
                    ),
                    controller: otpController,
                  ), */
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: PinCodeTextField(
                        keyboardType: TextInputType.number,

                        //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          errorBorderColor: Color.fromARGB(255, 255, 255, 255),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        //backgroundColor: Colors.blue.shade50,
                        //enableActiveFill: true,
                        //errorAnimationController: errorController,
                        controller: otpController,

                        onCompleted: (v) {
                          print("Completed");
                        },

                        onChanged: (value) {
                          print(value);
                        },

                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      )),
                  Center(
                    child: Container(
                        width: 120,
                        padding: const EdgeInsets.only(top: 40.0),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          //Verify
                          child: Text(AppLocalizations.of(context)!.verify,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontFamily: 'ProximaNovaRegular',
                                fontSize: 17,
                              )),
                          onPressed: () async {
                            // PhoneAuthCredential phoneAuthCredential =
                            //     PhoneAuthProvider.credential(
                            //         verificationId: verificationId,
                            //         smsCode: otpController.text);

                            // signInWithPhoneAuthCredential(
                            //     phoneAuthCredential); //original code
                            /*dummycode*/

                            if (otpController.text == '123456') {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Mainscreen()),
                                (Route<dynamic> route) => false,
                              );
                            }
                            /*dummycode ends*/
                          },
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(alignment: Alignment.center, children: <Widget>[
          Positioned(
              child: Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/BigBG.png"),
                  fit: BoxFit.cover),
            ),
          )),
          Positioned(
              top: 100,
              //left: ((constraints.maxWidth - 210) / 2),
              child: Container(
                  width: 218,
                  height: 288.45,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Logo.png'))))),
          Material(
            color: Colors.transparent,
            child: showLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black)),
                  )
                : (currentState == MobileVerificationState.SHOW_UID_FORM_STATE
                    ? getUIDFormWidget(context)
                    : getOTPFormWidget(context)),
          )
        ]);
      }),
    );
  }
}

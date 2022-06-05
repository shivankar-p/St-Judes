import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_screen.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;  //original code

  
  String phoneNum = "+911234567891";
  String testVerificationCode = "951597";

  late String verificationId;

  bool showLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _uidStatus(result) {
    setState(() {
      if (result == false) {
        _uidExists = "UID Does not exist. Please try again!";
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
        print('Caught some Exception ${e}');
        print(verificationId.length);
        print(verificationId);
        _otpValid = 'Invalid Otp. Please try again!';
      });
    }
  }

  getUIDFormWidget(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child:
                        Text(_uidExists, style: TextStyle(color: Colors.red))),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter your UID',
                    labelText: 'UID',
                  ),
                  controller: myController,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                    child: ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () async {
                        DatabaseReference _testRef = FirebaseDatabase.instance
                            .ref('uidToPhone/' + myController.text);
                        _testRef.onValue.listen((DatabaseEvent event) async {
                          final data = event.snapshot.value;
                          _uidStatus(event.snapshot.exists);
                          print(myController.text);
                          print(data.toString());
                          if (event.snapshot.exists) {
                            setState(() {
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
                            );  

                            
                            }
                        });
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getOTPFormWidget(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child:
                        Text( _otpValid, 
                        style: TextStyle(color: Colors.red))),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Enter your OTP',
                    labelText: 'OTP',
                  ),
                  controller: otpController,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                    child: ElevatedButton(
                      child: const Text('Verify'),
                      onPressed: () async {
                        PhoneAuthCredential phoneAuthCredential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: otpController.text);

                        signInWithPhoneAuthCredential(phoneAuthCredential);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('St Judes'),
      ),
      body: showLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (currentState == MobileVerificationState.SHOW_UID_FORM_STATE
              ? getUIDFormWidget(context)
              : getOTPFormWidget(context)),
    );
  }
}

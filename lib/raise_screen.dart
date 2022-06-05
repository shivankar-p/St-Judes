import 'package:flutter/material.dart';


class RaiseScreen extends StatefulWidget {
  @override
  State<RaiseScreen> createState() => _RaiseScreen();
}

class _RaiseScreen extends State<RaiseScreen> {
  

  final myController = TextEditingController();

  final otpController = TextEditingController();



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

    });
  }

  

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Scaffold(
      appBar: AppBar(
        title: Text('St Judes'),
      ),
      body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          const Text(
            'Have you been associated with St. Judes before?',
          ),
        ])));
  }
}
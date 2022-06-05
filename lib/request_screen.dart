import 'package:flutter/material.dart';

class RequestScreen extends StatefulWidget {
  @override
  RequestScreenState createState() {
    return new RequestScreenState();
  }
}

class RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Container(
                    padding: const EdgeInsets.only(left: 0, top: 20.0),
                    child: ElevatedButton(
                      child: const Text('Raise a request'),
                      onPressed: () async {
                        
                      }
                          
                        )),
        ])));
  }
}
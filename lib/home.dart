import 'package:firebase_database/firebase_database.dart';
import 'package:first/UID.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _associated = true;

  void _chooseAssociation(choice) {
   
    setState(() {
      _associated = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Have you been associated with St. Judes before?',
            ),
            ListTile(
                title: const Text('Yes'),
                leading: Radio(
                    value: true,
                    groupValue: _associated,
                    onChanged: _chooseAssociation)),
            ListTile(
                title: const Text('No'),
                leading: Radio(
                    value: false,
                    groupValue: _associated,
                    onChanged: _chooseAssociation)),
            ElevatedButton(
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UIDform();
                  }));
                })
            /*  Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ), */
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), */ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

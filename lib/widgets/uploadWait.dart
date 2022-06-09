import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'upload.dart';
import 'Raise_request.dart';

class UploadWait extends StatefulWidget {
  @override
  _UploadWaitState createState() => _UploadWaitState();
}

class _UploadWaitState extends State<UploadWait> {
  int _state = 3;
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('activerequests/15000/state');

  DatabaseReference ref1 =
      FirebaseDatabase.instance.ref('remarks/15000/remarks');

  DatabaseReference ref2 =
      FirebaseDatabase.instance.ref('activerequests/15000');

  late String statusdate, statusremarks;
  late int statusstate;

  getUploadData() async {
    var event = await ref2.child('docs').once();
    var data = event.snapshot.value as List<dynamic>;
    // var map = data.keys;
    List<String> stringlist = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] != null) {
        stringlist.add(i.toString());
        stringlist.add(data[i]['state'].toString());
      }
    }
    // map.forEach((doc) {
    //   stringlist.add(doc);
    //   stringlist.add(data[doc]['state'].toString());
    // });
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', stringlist);
  }

  getStatusData() async {
    var event = await ref1.once();
    var data = event.snapshot.value as String;

    event = await ref2.once();
    var data1 = event.snapshot.value as Map<dynamic, dynamic>;

    statusremarks = data;
    statusstate = data1['state'];
    statusdate = data1['date'];
  }

  checkValue() async {
    var event = await ref.once();
    var value = event.snapshot.value as int;
    setState(() {
      _state = value;
    });
    if (_state == 2) {
      getUploadData();
    } else {
      getStatusData();
    }
  }

  @override
  void initState() {
    super.initState();

    checkValue();

    ref.onValue.listen((event) {
      var value = event.snapshot.value as int;
      setState(() {
        _state = value;
      });
      if (_state == 2) {
        getUploadData();
      } else {
        getStatusData();
      }
    });
  }

  changeState(int i) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('request', i);

    if (i == 0) {
      var stringlist = prefs.getStringList('old');
      var list = [statusdate, statusremarks, statusstate.toString()];

      if (stringlist != null) {
        stringlist.addAll(list);
        await prefs.setStringList('old', stringlist);
      } else
        await prefs.setStringList('old', list);
    }
  }

  Widget displayScreen() {
    if (_state == 3) {
      return Center(
          child:
              const Text('Documents uploaded. wait till they are approved.'));
    } else if (_state == 2) {
      return Center(
          child: Column(children: [
        const Text('Problem with docs. please reupload them.'),
        ElevatedButton(
            child: Text('Upload Documents'),
            onPressed: () {
              changeState(2);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => (Upload())));
            })
      ]));
    }
    return Center(
        child: Column(children: [
      const Text('Congrats. Done. Team will contact soon.'),
      ElevatedButton(
          child: Text('Go back to home page'),
          onPressed: () {
            changeState(0);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => (RaiseRequest())));
          })
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return displayScreen();
  }
}

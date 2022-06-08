import 'package:first/widgets/Raise_request.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'upload.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestWait extends StatefulWidget {
  @override
  _RequestWaitState createState() => _RequestWaitState();
}

class _RequestWaitState extends State<RequestWait> {
  int _state = 1;
  DatabaseReference ref = FirebaseDatabase.instance.ref('activerequests/15000');

  getUploadData() async {
    var event = await ref.child('docs').once();
    var data = event.snapshot.value as Map<dynamic, dynamic>;
    var map = data.keys;
    List<String> stringlist = [];
    // for (int i = 0; i < map.length; i++) {
    //   if (map[i] != null) {
    //     stringlist.add(i.toString());
    //     stringlist.add(map[i]['state'].toString());
    //   }
    // }
    map.forEach((doc) {
      stringlist.add(doc);
      stringlist.add(data[doc]['state'].toString());
    });
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', stringlist);
  }

  checkValue() async {
    var event = await ref.once();
    var value = event.snapshot.value as Map<dynamic, dynamic>;
    setState(() {
      _state = value['state'];
    });
    if (_state == 2) {
      getUploadData();
    }
  }

  @override
  void initState() {
    super.initState();

    checkValue();

    ref.onValue.listen((event) {
      var value = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _state = value['state'];
      });
      if (_state == 2) {
        getUploadData();
      }
    });
  }

  changeState(int i) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('request', i);
  }

  Widget displayScreen() {
    if (_state == 1) {
      return Container(
          child: Center(
              child: const Text(
        'Request Raised. wait till it are approved.',
      )));
    } else if (_state == 2) {
      return Center(
          child: Column(children: [
        const Text('Approved.'),
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
      const Text('Not Aprroved. Go back simon'),
      ElevatedButton(
          child: Text('Go back'),
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

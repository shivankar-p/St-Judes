import 'package:first/widgets/Raise_request.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document.dart';

class RequestWait extends StatefulWidget {
  @override
  _RequestWaitState createState() => _RequestWaitState();
}

class _RequestWaitState extends State<RequestWait> {
  int _state = 1;
  DatabaseReference ref = FirebaseDatabase.instance.ref('activerequests/15000');

  late String rejectdate, rejectremarks;

  getUploadData() async {
    var event = await ref.child('docs').once();
    var data = event.snapshot.value as Map<dynamic, dynamic>;
    var map = data.keys;
    List<String> stringlist = [];
    // for (int i = 0; i < data.length; i++) {
    //   if (data[i] != null) {
    //     stringlist.add(i.toString());
    //     stringlist.add(data[i]['state'].toString());
    //   }
    // }
    map.forEach((doc) {
      stringlist.add(dockeys.indexOf(doc).toString());
      stringlist.add(data[doc]['state'].toString());
    });
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', stringlist);
  }

  getRejectData() async {
    var event = await ref.child('close_remarks').once();
    var data = event.snapshot.value as String;

    event = await ref.once();
    var data1 = event.snapshot.value as Map<dynamic, dynamic>;

    rejectremarks = data;
    rejectdate = data1['date'];
  }

  checkValue() async {
    var event = await ref.once();
    var value = event.snapshot.value as Map<dynamic, dynamic>;
    setState(() {
      _state = value['state'];
    });
    if (_state == 2) {
      getUploadData();
    } else if (_state == -1) {
      getRejectData();
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
      } else if (_state == -1) {
        getRejectData();
      }
    });
  }

  changeState(int i) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('request', i);

    if (i == 0) {
      var stringlist = prefs.getStringList('old');
      var list = [rejectdate, rejectremarks, '-1'];

      if (stringlist != null) {
        stringlist.addAll(list);
        await prefs.setStringList('old', stringlist);
      } else
        await prefs.setStringList('old', list);
    }
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

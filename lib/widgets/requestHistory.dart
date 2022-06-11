import 'package:first/widgets/uploadWait.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future notif;
  int _itemCount = 0;
  var messages = [];
  DatabaseReference ref = FirebaseDatabase.instance.ref('notifications/12345');

  Future getData() async {
    var event = await ref.once();
    var data = event.snapshot.value as List<dynamic>;
    setState(() {
      _itemCount = data.length;
      messages = data;
    });

    return data;
  }

  Widget displayNotifs(BuildContext ctx) {
    return ListView.separated(
        itemCount: _itemCount,
        separatorBuilder: (ctx, index) => Divider(),
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(messages[index]['date']),
            isThreeLine: true,
            subtitle: Text(messages[index]['msg']),
            leading: CircleAvatar(child: Text('AD')),
            trailing: Text(messages[index]['time']),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    notif = getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "hi",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios_new),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('FAQs'),
        ),
        body: displayNotifs(context),
      ),
    );
  }
}

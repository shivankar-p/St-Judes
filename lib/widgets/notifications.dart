import 'package:first/widgets/uploadWait.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
    return RefreshIndicator(
        child: ListView.separated(
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
            }),
        onRefresh: getData,
        displacement: 100);
  }

  @override
  void initState() {
    super.initState();
    print("init not");
    notif = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: notif,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('There is an error ${snapshot.error.toString()}');
          return Text('Something went wrong');
        } else if (snapshot.hasData) {
          return displayNotifs(context);
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}

import 'package:first/widgets/uploadWait.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  static final _notifications = FlutterLocalNotificationsPlugin();
  late Future notif;
  int _itemCount = 0;
  var messages = [];
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);
  DatabaseReference ref = FirebaseDatabase.instance.ref('notifications/15000');

  Future getData() async {
    await _notifications.initialize(InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')));
    var event = await ref.once();
    var data = event.snapshot.value as List<dynamic>;
    setState(() {
      _itemCount = data.length;
      messages = List.from(data.reversed);
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
                title: Text(messages[index]['msg'].split(':')[0]),
                // isThreeLine: true,
                subtitle: Text(messages[index]['msg'].split(':')[1]),
                leading: CircleAvatar(child: Text('AD')),
                trailing: Text(messages[index]['date']),
              );
            }),
        onRefresh: getData,
        displacement: 100);
  }

  static Future _showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async =>
      await _notifications.show(
          id,
          title,
          body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            playSound: true,
            importance: channel.importance,
          )));

  @override
  void initState() {
    super.initState();
    notif = getData();

    ref.onValue.listen((event) {
      var data = event.snapshot.value as List<dynamic>;
      setState(() {
        _itemCount = data.length;
        messages = List.from(data.reversed);
      });

      if (messages.isNotEmpty) {
        _showNotification(
            id: 0,
            title: messages.last['msg'].split(':')[0],
            body: messages.last['msg'].split(':')[1]);
      }
    });
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

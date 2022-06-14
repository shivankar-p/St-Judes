import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/uidvalue.dart';

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
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('notifications/${UIDValue.uid}');

  Future getData() async {
    await _notifications.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')));
    var event = await ref.once();
    if (event.snapshot.value == null) return [];
    var data = event.snapshot.value as Map<dynamic, dynamic>;
    var x = data.keys;
    setState(() {
      _itemCount = x.length;
      messages = List.from(List.from(data.values).reversed);
    });

    return data;
  }

  Widget displayNotifs(BuildContext ctx) {
    if (messages.isEmpty) {
      return Center(
        child: Text('There are no notifications currently.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontFamily: 'ProximaNovaRegular',
              fontSize: 20,
            )),
      );
    }
    return RefreshIndicator(
        child: ListView.separated(
            itemCount: _itemCount,
            separatorBuilder: (ctx, index) => Divider(),
            itemBuilder: (ctx, index) {
              var message = messages[index]['msg'].split(':');
              if (message.length == 1) {
                return ListTile(
                  title: Text('MESSAGE FROM ADMIN'),
                  isThreeLine: true,
                  subtitle: Text(message[0]),
                  leading: CircleAvatar(child: Text('AD')),
                  trailing: Text(messages[index]['date']),
                );
              } else
                return ListTile(
                  title: Text(message[0]),
                  isThreeLine: true,
                  subtitle: Text(message[1]),
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
    ref.onChildAdded.listen((event) {
      if (event.snapshot.value == null) return;
      var data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _itemCount++;
        messages.insert(0, data);
      });

      if (data.isNotEmpty) {
        var message = data['msg'].split(':');
        if (message.length == 1) {
          _showNotification(
              id: 0, title: 'Message from Admin', body: message[0]);
        } else {
          _showNotification(id: 0, title: message[0], body: message[1]);
        }
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

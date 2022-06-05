import 'package:flutter/material.dart';
import 'UID.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  TextEditingController myController = TextEditingController();

  ProfilePage(this.myController);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  void _phoneStatus() {
    setState(() {
      DatabaseReference _testRef = FirebaseDatabase.instance
          .ref('uidToPhone/' + widget.myController.text + '/phone');
      _testRef.onValue.listen((DatabaseEvent event) async {
        final data = event.snapshot.value;
        phoneController.text = data.toString();
        print(widget.myController.text);
        print(data.toString());
      });

      DatabaseReference _nameRef = FirebaseDatabase.instance
          .ref('uidToPhone/' + widget.myController.text + '/name');
      _nameRef.onValue.listen((DatabaseEvent event) async {
        final namedata = event.snapshot.value;
        nameController.text= namedata.toString();
        print(nameController.text);
    });
  });}

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    _phoneStatus();
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.key),
                            hintText: 'Enter your UID',
                            labelText: 'UID',
                            enabled: false,
                          ),
                          controller: widget.myController,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Enter your UID',
                            labelText: 'Name',
                            enabled: false,
                          ),
                          controller: nameController,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            hintText: 'Enter your UID',
                            labelText: 'Phone',
                            enabled: false,
                          ),
                          controller: phoneController,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}

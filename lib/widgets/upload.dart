import 'dart:collection';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:first/widgets/uploadWait.dart';
import 'package:first/widgets/documentcapture.dart';

import '../models/document.dart';
import 'slidingdots.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  UploadTask? task;
  int _currentpage = 0;
  int _numberOfDocuments = 0;
  int _numberUploaded = 0;

  late Future notif;
  Map pagemap = {};

  late var typestatelist;
  late DatabaseReference ref1;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future getStateFromSF() async {
    var prefs = await SharedPreferences.getInstance();
    final stringlist = prefs.getStringList('items');
    int nod = 0;
    print(stringlist);
    for (var i = 0; i < stringlist!.length; i += 2) {
      int state = int.parse(stringlist[i + 1]);

      if (state == 0) {
        pagemap[nod] = int.parse(stringlist[i]);
        setState(() {
          nod++;
        });
      }
      doctypes[int.parse(stringlist[i])].docState = state;
    }
    setState(() {
      _numberOfDocuments = nod;
    });
    for (int i = 0; i < _numberOfDocuments; i++) {
      typestatelist.add(0);
    }
    print(pagemap);
    return _numberOfDocuments;
  }

  getuid() async {
    var prefs = await SharedPreferences.getInstance();
    String _uid = prefs.getString('loginstate')!;
    DatabaseReference ref1 =
        FirebaseDatabase.instance.ref('activerequests/$_uid');
  }

  @override
  void initState() {
    super.initState();
    getuid();
    typestatelist = [];
    notif = getStateFromSF();
  }

  moveToPage() {
    _pageController.animateToPage(_currentpage,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  _onPageChanged(int index) {
    setState(() {
      _currentpage = index;
    });
  }

  Future uploadFile(pickedFile, page) async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    var ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      task = ref.putFile(file);
    });

    final snapshot = await task!.whenComplete(() {});
    var downloadUrl = await ref.getDownloadURL();
    doctypes[page].urls.add(downloadUrl);

    var newref = ref1.child('docs/${dockeys[page]}/url').push();
    newref.set(downloadUrl);

    setState(() {
      task = null;
    });
  }

  void submitDocs() {
    if (typestatelist[_currentpage] == 1) return;
    if (doctypes[pagemap[_currentpage]].docpaths.isNotEmpty) {
      int page = pagemap[_currentpage];
      var l = doctypes[page].docpaths.length;
      for (int i = 0; i < l; i++) {
        uploadFile(doctypes[page].docpaths[i], page);
        if (i == l - 1) {
          ref1.child('docs/${dockeys[page]}/state').set(1);
        }
      }

      setState(() {
        _numberUploaded++;
        typestatelist[_currentpage] = 1;
      });

      if (_numberUploaded == _numberOfDocuments) {
        ref1.child('state').set(3);
        changeState(3);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UploadWait()));
      }

      if (_currentpage <= _numberOfDocuments - 2) {
        setState(() {
          _currentpage++;
        });
        moveToPage();
      }
    }
  }

  changeState(int i) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt('request', i);
  }

  Widget showScreen() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        PageView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _numberOfDocuments,
            itemBuilder: (ctx, i) =>
                Documentcapture(pagemap[i], typestatelist[i])),
      ])),
      Container(
        margin: EdgeInsets.only(bottom: 50),
        child: SizedBox(
            width: 200,
            child:
                ElevatedButton(child: Text('Submit'), onPressed: submitDocs)),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int i = 0; i < _numberOfDocuments; i++)
            if (i == _currentpage) Slidingdots(true) else Slidingdots(false)
        ]),
      )
    ]);
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
          return showScreen();
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}

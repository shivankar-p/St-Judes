import 'package:flutter/material.dart';
import '../widgets/HeroDialogue.dart';
import 'UID.dart';

String language = "English (default)";

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(children: <Widget>[
        Positioned(
            child: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/BigBG.png"),
                fit: BoxFit.cover),
          ),
        )),
        Positioned(
            top: 100 * (constraints.maxHeight / 800),
            left: ((constraints.maxWidth - 213) / 2),
            child: Container(
                width: 218,
                height: 288.45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Logo.png'))))),
        Positioned(
            top: 410 * (constraints.maxHeight / 800),
            left: ((constraints.maxWidth - 203) / 2),
            child: Material(
                color: Colors.transparent,
                child: Text('Select language',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'ProximaNovaRegular',
                      fontSize: 30,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    )))),
        Positioned(
            top: 450 * (constraints.maxHeight / 800),
            left: (constraints.maxWidth - 237) / 2,
            child: Hero(
                tag: "SelectLang",
                child: Material(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(HeroDialogRoute(builder: (context) {
                            return const LanguageList();
                          }));
                        },
                        child: Container(
                            height: 40,
                            width: 250,
                            child: Center(
                                child: Text(language,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontFamily: 'ProximaNovaRegular',
                                        fontSize: 20,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                        height: 1)))))))),
        Positioned(
            top: 530 * (constraints.maxHeight / 800),
            left: (constraints.maxWidth - 100) / 2,
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return UIDform();
                  }));
                },
                child: Hero(
                    tag: "Transition1",
                    child: Material(
                        color: Color.fromARGB(255, 0, 0, 0),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Stack(children: [
                          SizedBox(
                            width: 110,
                            height: 35,
                          ),
                          Positioned(
                              top: 7,
                              left: 20,
                              child: Text('Continue',
                                  style: TextStyle(
                                      fontFamily: 'ProximaNovaRegular',
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255))))
                        ])))))
      ]);
    });
  }
}

class LanguageList extends StatefulWidget {
  const LanguageList({Key? key}) : super(key: key);

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Hero(
            tag: "SelectLang",
            child: GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    width: 230,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: <Widget>[
                          Card(
                              child: ListTile(
                                  title: Center(
                                      child: Text('English (default)',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0)))),
                                  onTap: () {
                                    setState(() {
                                      language = 'English (default)';
                                    });
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return const Language();
                                    }));
                                  },
                                  tileColor:
                                      Color.fromARGB(255, 255, 255, 255))),
                          Card(
                              child: ListTile(
                                  title: Center(
                                      child: Text('தமிழ் (Tamil)',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0)))),
                                  onTap: () {
                                    setState(() {
                                      language = 'தமிழ் (Tamil)';
                                    });
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return const Language();
                                    }));
                                  },
                                  tileColor:
                                      Color.fromARGB(255, 255, 255, 255))),
                          Card(
                              child: ListTile(
                                  title: Center(
                                      child: Text('తెలుగు (Telugu)',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0)))),
                                  onTap: () {
                                    setState(() {
                                      language = 'తెలుగు (Telugu)';
                                    });
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return const Language();
                                    }));
                                  },
                                  tileColor:
                                      Color.fromARGB(255, 255, 255, 255))),
                          Card(
                              child: ListTile(
                                  title: Center(
                                      child: Text('हिन्दी (Hindi)',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0)))),
                                  onTap: () {
                                    setState(() {
                                      language = 'हिन्दी (Hindi)';
                                    });
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return const Language();
                                    }));
                                  },
                                  tileColor:
                                      Color.fromARGB(255, 255, 255, 255))),
                          Card(
                              child: ListTile(
                                  title: Center(
                                      child: Text('മലയാളം (Malayalam)',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0)))),
                                  onTap: () {
                                    setState(() {
                                      language = 'മലയാളം (Malayalam)';
                                    });
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return const Language();
                                    }));
                                  },
                                  tileColor:
                                      Color.fromARGB(255, 255, 255, 255))),
                          Card(
                              child: ListTile(
                                  title: Center(
                                      child: Text('বাংলা (Bengali)',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0)))),
                                  onTap: () {
                                    setState(() {
                                      language = 'বাংলা (Bengali)';
                                    });
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return const Language();
                                    }));
                                  },
                                  tileColor:
                                      Color.fromARGB(255, 255, 255, 255))),
                        ])))));
  }
}

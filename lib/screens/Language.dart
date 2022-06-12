import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../LocaleProvider.dart';
import '../widgets/HeroDialogue.dart';
import 'UID.dart';
import 'package:shared_preferences/shared_preferences.dart';

String language = "English (default)";
double font_size = 30;

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  List<String> _languages = [
    'English (default)',
    'தமிழ் (Tamil)',
    'తెలుగు (Telugu)',
    'हिन्दी (Hindi)',
    'മലയാളം (Malayalam)',
    'বাংলা (Bengali)'
  ];

  var _locales = ['en', 'ta', 'te', 'hi', 'ml', 'bl'];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(alignment: Alignment.center, children: <Widget>[
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
            //left: ((constraints.maxWidth - 213) / 2),
            child: Container(
                width: 218,
                height: 288.45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Logo.png'))))),
        Positioned(
            top: 350 * (constraints.maxHeight / 800),
            child: SizedBox(
              width: 350,
              child: Material(
                  color: Color.fromARGB(0, 255, 255, 255),
                  child: Text(
                      //Select Language
                      'St Judes India Childcares',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 27, 63, 27),
                        fontFamily: 'ProximaNovaRegular',
                        fontSize: 27,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ))),
            )),
        Positioned(
            top: 500 * (constraints.maxHeight / 800),
            child: SizedBox(
              width: 300,
              child: Material(
                  color: Color.fromARGB(0, 255, 255, 255),
                  child: Text(
                      //Select Language
                      AppLocalizations.of(context)!.selectLanguage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'ProximaNovaRegular',
                        fontSize: font_size,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ))),
            )),
        Positioned(
            top: 550 * (constraints.maxHeight / 800),
            //left: (constraints.maxWidth - 237) / 2,
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
            top: 700 * (constraints.maxHeight / 800),
            //left: (constraints.maxWidth - 100) / 2,
            child: GestureDetector(
                onTap: () async {
                  var prefs = await SharedPreferences.getInstance();
                  final stringlist = prefs.setString(
                      'locale', _locales[_languages.indexOf(language)]);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
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
                        child: Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            width: 300,
                            height: 40,
                          ),
                          Positioned(
                              top: 9,
                              //left: 20,
                              //Continue
                              child: Text(AppLocalizations.of(context)!.cont,
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
    final provider = Provider.of<LocaleProvider>(context);
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
                        padding: EdgeInsets.zero,
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
                                    provider.setLocale(Locale('en'));
                                    setState(() {
                                      language = 'English (default)';
                                      font_size = 30;
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
                                    provider.setLocale(Locale('ta'));
                                    setState(() {
                                      language = 'தமிழ் (Tamil)';
                                      font_size = 25;
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
                                    provider.setLocale(Locale('te'));
                                    setState(() {
                                      language = 'తెలుగు (Telugu)';
                                      font_size = 30;
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
                                    provider.setLocale(Locale('hi'));
                                    setState(() {
                                      language = 'हिन्दी (Hindi)';
                                      font_size = 30;
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
                                    provider.setLocale(Locale('ml'));
                                    setState(() {
                                      language = 'മലയാളം (Malayalam)';
                                      font_size = 26;
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
                                    provider.setLocale(Locale('bn'));
                                    setState(() {
                                      language = 'বাংলা (Bengali)';
                                      font_size = 30;
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

                  // final provider =
                  //     Provider.of<LocaleProvider>(context, listen: false);
                  // provider.setLocale(locale);
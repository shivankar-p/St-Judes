import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    required this.questionType,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  String questionType;
  bool isExpanded;
}

class FAQ extends StatefulWidget {
  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  static const request =
      "మా ప్రక్రియలో మీరు అభ్యర్థనను అందజేయడం, ప్రోగ్రామ్‌కు అర్హత పొందడం, అవసరమైన పత్రాలను అప్‌లోడ్ చేయడం మరియు ఆమోదం పొందిన తర్వాత మీరు ప్రోగ్రామ్‌లో పరిగణించబడతారు.";
  //"Our process involves you to raise a request, become eligible for the program, upload the required documents and then on approval you shall be considered in the program.";
  static const education1 =
      "We provide education loans to regular students good at their academics, and for those who wish to pursue higher studies.";
  static const education2 =
      "The criterion which needs to be satisfied for an education loan include regular attendence, consistency in grades and minimal prior help received.";
  static const upload =
      "On the upload screen of the app, you are required to either click a picture with your camera, upload a photo from gallery, or send us a document like a PDF";
  static const counselling =
      "On applying for counselling, you shall be given an appointment and connected to one of our organization's counsellors to help you out.";

  final List<Item> data = [
    Item(
        expandedValue: request,
        headerValue: "Raising a Request",
        questionType: "Request"),
    Item(
        expandedValue: education1,
        headerValue: "Education loans",
        questionType: "Education"),
    Item(
        expandedValue: education2,
        headerValue: "Required Criterion",
        questionType: "Education"),
    Item(
        expandedValue: upload,
        headerValue: "Uploading of Documents",
        questionType: "Upload"),
    Item(
        expandedValue: counselling,
        headerValue: "Counselling Process",
        questionType: "Counselling"),
  ];
  static List<Item> filteredData = [];

  callback(str) {
    setState(() {
      filteredData = data.where((item) => item.questionType == str).toList();
    });
  }

  @override
  void initState() {
    filteredData = this.data;
    super.initState();
  }

  Widget show() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  filteredData = data;
                });
              },
              child: Text("All"),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  //side: BorderSide(color: Colors.red)
                )),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.redAccent; //<-- SEE HERE
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
            ),
            FilterButton(txt: "Education", callback: callback),
            FilterButton(txt: "Upload", callback: callback),
            FilterButton(txt: "Request", callback: callback),
            FilterButton(txt: "Counselling", callback: callback)
          ]),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              child: _buildPanel(),
            ),
          ),
          SpeechWidget(data: this.data),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Frequently Asked Questions",
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
        body: show(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          filteredData[index].isExpanded = !isExpanded;
        });
      },
      children: filteredData.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String txt;
  final Function callback;
  FilterButton({required this.txt, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        callback(txt);
      },
      child: Text(txt),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          //side: BorderSide(color: Colors.red)
        )),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Colors.redAccent; //<-- SEE HERE
            return null; // Defer to the widget's default.
          },
        ),
      ),
    );
  }
}

class SpeechWidget extends StatefulWidget {
  final List<Item> data;
  SpeechWidget({Key? key, required this.data}) : super(key: key);

  @override
  _SpeechWidgetState createState() => _SpeechWidgetState();
}

class _SpeechWidgetState extends State<SpeechWidget> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  List<Item> data = [];
  final flutterTts = FlutterTts();
  String possibleAnswer = 'Never gonna give you up';
  List<Item> filteredData = [];

  initializeSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeSpeech();
    data = widget.data;
  }

  Future _speak() async {
    await flutterTts.setLanguage("te-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(possibleAnswer);
  }

  findPossibleAnswer(str) {
    if (str.toLowerCase().contains("education")) {
      setState(() {
        filteredData =
            data.where((item) => item.questionType == "Education").toList();
        possibleAnswer = filteredData[0].expandedValue;
      });
    } else if (str.toLowerCase().contains("upload")) {
      setState(() {
        filteredData =
            data.where((item) => item.questionType == "Upload").toList();
        possibleAnswer = filteredData[0].expandedValue;
      });
    } else if (str.toLowerCase().contains("request")) {
      setState(() {
        filteredData =
            data.where((item) => item.questionType == "Request").toList();
        possibleAnswer = filteredData[0].expandedValue;
      });
    } else if (str.toLowerCase().contains("counselling")) {
      setState(() {
        filteredData =
            data.where((item) => item.questionType == "Counselling").toList();
        possibleAnswer = filteredData[0].expandedValue;
      });
    } else {
      setState(() {
        possibleAnswer =
            "I don't know the answer for that right now, please check the questions below.";
      });
    }
    _speak();
  }

  TextEditingController questiontext = TextEditingController();
  @override
  Widget build(BuildContext context) {
    questiontext.text = _text;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Or ask your question directly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'ProximaNovaRegular',
                  fontSize: 20,
                )),
            AvatarGlow(
              animate: _isListening,
              glowColor: Theme.of(context).primaryColor,
              endRadius: 50.0,
              duration: const Duration(milliseconds: 2000),
              repeatPauseDuration: const Duration(milliseconds: 100),
              repeat: true,
              child: FloatingActionButton(
                onPressed: _listen,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
                controller: questiontext,
                enabled: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: OutlineInputBorder()))),
        Container(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
              onPressed: () {
                findPossibleAnswer(_text);
              },
              child: Text('Ask Answer')),
        ),
      ],
    );
  }

  void _listen() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
        }),
      );
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }
}
/*
class _SpeechWidgetState extends State<SpeechWidget> {
  SpeechToText _speechToText =  SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  @override
  void initState()
  {
    super.initState();
    _initSpeech();
  }
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() { });
  }
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }
  void _onSpeechResult(SpeechRecognitionResult result)
  {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }
  @override 
  Widget build(BuildContext context) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: <Widget>[
            FloatingActionButton(
              onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
              tooltip: 'Ask Question',
              child: Icon(_speechToText.isNotListening ? Icons.mic_none : Icons.mic)
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text("Recognized words:")
            ),
            
            Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _speechToText.isListening ? 
                  '$_lastWords' : _speechEnabled ? 
                  "Tap the microphone button and ask question" : "Ask question not available",
                ),
            )
        
          ]
      );
  }
}
*/
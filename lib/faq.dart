//import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Frequently Asked Questions';
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(primarySwatch: Colors.orange), 
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: 
        const MyStatefulWidget(),
      
    ),
  );
}
}

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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. At erat pellentesque adipiscing commodo elit at imperdiet dui. Orci sagittis eu volutpat odio facilisis mauris sit amet.";
  final List<Item> data = [
    Item(expandedValue: "Never gonna give you up Never gonna let you down Never gonna run around and desert you", headerValue: "Question 1", questionType: "Money"),
    Item(expandedValue: str, headerValue: "Question 2", questionType: "Education"),
    Item(expandedValue: str, headerValue: "Question 3", questionType: "Education"),
    Item(expandedValue: str, headerValue: "Question 4", questionType: "Upload"),
    Item(expandedValue: "The answer for your question is RYAN STARTED THE FIRE!!", headerValue: "Question 5", questionType: "Upload"),
  ];
  static List<Item> filteredData = [];

  callback(str){
    setState(() {
      filteredData = data.where((item) => item.questionType==str).toList(); 
    });
  }
  
  @override
  void initState() {
    filteredData = this.data;    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(children: 
    [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            
            ElevatedButton(onPressed: () { setState(() {
              filteredData = data;
            });},
            child: Text("All"),
            style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.red)
                    )
                  ),

                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.redAccent; //<-- SEE HERE
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
            ),
          
            FilterButton(txt: "Money", callback: callback),
            FilterButton(txt: "Education", callback: callback),
            FilterButton(txt: "Upload", callback: callback),
          ]
        ), 
    
    SpeechWidget(data: this.data),

    SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    )
  ]);
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
  Widget build(BuildContext context)
  {
    return  ElevatedButton(onPressed: () {callback(txt);},
              child: Text(txt),
              style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        //side: BorderSide(color: Colors.red)
                      )
                    ),

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
  SpeechWidget({Key? key, required this.data}) : super(key:key);

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

    @override
    void initState() {
      super.initState();
      _speech = stt.SpeechToText();
      data = widget.data;
    }

    Future _speak() async{
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(possibleAnswer);
    }

    findPossibleAnswer(str)
    {
      if(str.toLowerCase().contains("education")){
        setState(() {
          filteredData = data.where((item) => item.questionType=="Education").toList(); 
          possibleAnswer = filteredData[0].expandedValue;
      });
      }

      else if(str.toLowerCase().contains("money")){
        setState(() {
          filteredData = data.where((item) => item.questionType=="Money").toList(); 
          possibleAnswer = filteredData[0].expandedValue;
      });
      }
    
      else if(str.toLowerCase().contains("upload")){
        setState(() {
          filteredData = data.where((item) => item.questionType=="Upload").toList(); 
          possibleAnswer = filteredData[0].expandedValue;
      });
      }

      else{
        setState(() {
          possibleAnswer = "I don't know the answer for that right now, check the questions below.";
        });    
      }
      print(data);
      _speak();
    }

    @override
    Widget build(BuildContext context) {
        return Column(
          children: [
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

            Container(
              padding: EdgeInsets.all(10),
              child: Text("Your Question:")
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 75.0),
              child: Text(_text, textAlign: TextAlign.center)
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(onPressed:(){findPossibleAnswer(_text);} , child: Text('Ask Answer')),
            ),
            
          ],
      );
    }

    void _listen() async {
      if (!_isListening) {
        bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
        );
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) => setState(() {
              _text = val.recognizedWords;
              print(_text);
            }),
          );
          
        }
      } else {
        setState(() {
            _isListening = false;
        } );
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
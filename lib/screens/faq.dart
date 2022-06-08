import 'package:flutter/material.dart';

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
  static const str =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. At erat pellentesque adipiscing commodo elit at imperdiet dui. Orci sagittis eu volutpat odio facilisis mauris sit amet.";
  final List<Item> data = [
    Item(
        expandedValue: str,
        headerValue: "Question 1",
        questionType: "Filter 1"),
    Item(
        expandedValue: str,
        headerValue: "Question 2",
        questionType: "Filter 2"),
    Item(
        expandedValue: str,
        headerValue: "Question 3",
        questionType: "Filter 2"),
    Item(
        expandedValue: str,
        headerValue: "Question 4",
        questionType: "Filter 3"),
    Item(
        expandedValue: str,
        headerValue: "Question 5",
        questionType: "Filter 1"),
  ];
  static List<Item> filteredData = [];

  callback(str) {
    setState(() {
      filteredData = data.where((item) => item.questionType == str).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    filteredData = this.data;
    super.initState();
  }

  Widget show() {
    return ListView(children: [
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
        FilterButton(txt: "Filter 1", callback: callback),
        FilterButton(txt: "Filter 2", callback: callback),
        FilterButton(txt: "Filter 3", callback: callback),
      ]),
      SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      )
    ]);
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

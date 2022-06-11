import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  DatabaseReference ref = FirebaseDatabase.instance.ref('queries');

  static const NUMBER = '+918130494605';
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  _callNumber() async {
    await FlutterPhoneDirectCaller.callNumber(NUMBER);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: SizedBox(
                height: 500,
                width: 320,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(children: [
                      Text('Contact Us'),
                      Text(
                          'Write us your query and we ll get back to you soon'),
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                            height: 200,
                            child: TextField(
                              controller: myController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter City Here'),
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.top,
                              expands: true,
                              maxLines: null,
                            ));
                      }),
                      SizedBox(
                          width: 200,
                          child: ElevatedButton(
                              child: Text('Submit'),
                              onPressed: () {
                                if (myController.text.isNotEmpty) {
                                  var newref = ref.push();
                                  newref.set({
                                    'msg': myController.text,
                                    'uid': '15000',
                                    'date': DateFormat("dd MMMM yyyy")
                                        .format(DateTime.now()),
                                    'time': DateFormat("HH:mm:ss")
                                        .format(DateTime.now())
                                  });
                                }
                                Navigator.pop(context);
                              })),
                      Text('or call us on our numbers'),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: _callNumber,
                        child: const Text('Call'),
                      )
                    ]))),
          ),
        ),
      ),
    );
  }
}

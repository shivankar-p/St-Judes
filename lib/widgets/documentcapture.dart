import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/document.dart';
import 'upload.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class SelectMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectModeState();
}

class SelectModeState extends State<SelectMode>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(45.0),
            child: SizedBox(
              width: 150,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context, 1);
                    }),
                SizedBox(width: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Icon(
                      Icons.file_open,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context, 2);
                    })
              ]),
            ),
          ),
        ),
      ),
    ));
  }
}

class Documentcapture extends StatefulWidget {
  final int index;
  final int state;
  Documentcapture(this.index, this.state);
  @override
  _DocumentcaptureState createState() => _DocumentcaptureState(index, state);
}

class _DocumentcaptureState extends State<Documentcapture> {
  final int _index;
  final int _state;
  int _docState = 0;
  _DocumentcaptureState(this._index, this._state);

  List<String> _imagepaths = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _docState = _state;
      doctypes[_index]
          .docpaths
          .forEach((element) => {_imagepaths.add(element.path)});
    });
  }

  Widget getLine1() {
    var line1;
    if (_docState == 0) {
      line1 = 'Please upload your';
    } else {
      line1 = 'Your ${doctypes[_index].name} has been';
    }

    return Text(line1,
        textAlign: TextAlign.left,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget getLine2() {
    var line2;
    if (_docState == 0) {
      line2 = doctypes[_index].name;
      return Text(line2,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold));
    } else {
      if (_docState == 1) {
        line2 = "Uploaded";
      } else {
        line2 = 'Approved';
      }

      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: line2,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            const WidgetSpan(
              child: Icon(
                Icons.check_circle,
                size: 32,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget emptyContainer() {
    return Container(
      child: const Center(
          child: Text('No file Selected. Click + to add documents')),
    );
  }

  removeFiles() {
    setState(() {
      doctypes[_index].docpaths.clear();
      _imagepaths.clear();
    });
  }

  Future selectFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        result.files.forEach((element) {
          doctypes[_index].docpaths.add(element);
          _imagepaths.add(element.path!);
        });
      });
    }
  }

  Future captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        doctypes[_index].docpaths.add(photo.path);
        _imagepaths.add(photo.path);
      });
    }
  }

  Widget generateAddButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
        ),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () async {
          var val =
              await showDialog(context: context, builder: (_) => SelectMode());
          if (val == 2)
            selectFiles();
          else if (val == 1)
            captureImage();
          else
            return;
        });
  }

  Widget generateDelButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15),
      ),
      child: const Icon(
        Icons.delete,
        size: 30,
      ),
      onPressed: removeFiles,
    );
  }

  Widget imagePreview(String path) {
    if (path.substring(path.length - 3) == 'pdf') {
      return Padding(
          padding: const EdgeInsets.only(left: 28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // padding: EdgeInsets.only(left: 16),
            child: Column(children: [
              SvgPicture.asset(
                'assets/images/PDF_file_icon.svg',
                height: 150,
              ),
              SizedBox(
                  width: 150,
                  child: Text(path.split('/').last,
                      overflow: TextOverflow.clip, maxLines: 2, softWrap: true))
            ]),
          ));
    } else {
      return Padding(
          padding: const EdgeInsets.only(left: 28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // padding: EdgeInsets.only(left: 16),
            child: Image.file(File(path)),
          ));
    }
  }

  Widget showPreview() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          child: SizedBox(
        height: 200,
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [..._imagepaths.map((ele) => imagePreview(ele))],
        ),
      ))
    ]));
  }

  String files = "No File Selected. Click + to add documents";

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 28, top: 80),
            child: getLine1(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: getLine2(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 10, right: 28),
            child: Text(doctypes[_index].desc,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          if (_imagepaths.length > 0) showPreview(),
          if (_imagepaths.length == 0) emptyContainer(),
          SizedBox(height: 30),
          if (_docState == 0)
            Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              generateAddButton(),
              const SizedBox(
                width: 20,
              ),
              generateDelButton()
            ])),
        ]);
  }

  // Future captureImage() async {
  //   var image = await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     setState(() {
  //       _imagepaths.add(image.path);
  //       files = "Selected Files";
  //     });
  //   }
  // }
}

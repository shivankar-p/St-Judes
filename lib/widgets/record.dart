import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum AudioState { recording, stop, play }

const veryDarkBlue = Color(0xff172133);
const kindaDarkBlue = Color(0xff202641);

class SoundRecorder {
  final String _path;
  SoundRecorder(this._path);
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _player;
  bool _isRecorderInit = false;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Not granted');
    }
    await _player!.openAudioSession();

    await _audioRecorder!.openAudioSession();
    _isRecorderInit = true;
  }

  void dispose() {
    _audioRecorder!.closeAudioSession();
    _player!.openAudioSession();
    _audioRecorder = null;
    _isRecorderInit = false;
  }

  Future record() async {
    if (!_isRecorderInit) return;
    await _audioRecorder!.startRecorder(codec: Codec.aacMP4, toFile: _path);
  }

  Future stop() async {
    if (!_isRecorderInit) return;
    await _audioRecorder!.stopRecorder();
  }

  void play() {
    _player!.startPlayer(fromURI: _path);
  }

  void stopPlayer() {
    _player!.stopPlayer();
  }

  Future toggle() async {
    if (_audioRecorder!.isStopped) {
      await record();
    } else {
      await stop();
    }
  }
}

class Record extends StatefulWidget {
  final String _path;
  const Record(this._path);

  @override
  _RecordState createState() => _RecordState(_path);
}

class _RecordState extends State<Record> {
  final String _path;
  UploadTask? task;
  _RecordState(this._path);
  DatabaseReference ref1 =
      FirebaseDatabase.instance.ref('/activerequests/15000');

  AudioState? audioState = null;
  late final recorder;

  Future uploadFile() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + '/$_path';
    final file = File(tempPath);

    var ref = FirebaseStorage.instance.ref().child('files/$_path');
    setState(() {
      task = ref.putFile(file);
    });

    final snapshot = await task!.whenComplete(() {});
    var downloadUrl = await ref.getDownloadURL();

    ref1.child('voicenote').set(downloadUrl);

    setState(() {
      task = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recorder = SoundRecorder(_path);
    recorder.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    recorder.dispose();
    super.dispose();
  }

  void handleAudioState(AudioState? state) {
    setState(() {
      if (audioState == null) {
        audioState = AudioState.recording;
        recorder.record();
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.play;
        recorder.stop();
        // uploadFile();
      } else if (audioState == AudioState.play) {
        audioState = AudioState.stop;
        recorder.play();
      } else if (audioState == AudioState.stop) {
        audioState = AudioState.play;
        recorder.stopPlayer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microphone Flutter Web',
      home: Scaffold(
        backgroundColor: veryDarkBlue,
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: handleAudioColour(audioState)),
                child: RawMaterialButton(
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(30),
                  onPressed: () => handleAudioState(audioState),
                  child: getIcon(audioState),
                ),
              ),
              SizedBox(width: 20),
              if (audioState == AudioState.play ||
                  audioState == AudioState.stop)
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kindaDarkBlue,
                  ),
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(30),
                    onPressed: () => setState(() {
                      audioState = null;
                    }),
                    child: Icon(Icons.replay, size: 50),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color handleAudioColour(AudioState? state) {
    if (audioState == AudioState.recording) {
      return Colors.deepOrangeAccent.shade700.withOpacity(0.5);
    } else if (audioState == AudioState.stop) {
      return Colors.green.shade900;
    } else {
      return kindaDarkBlue;
    }
  }

  Icon getIcon(AudioState? state) {
    switch (state) {
      case AudioState.play:
        return Icon(Icons.play_arrow, size: 50);
      case AudioState.stop:
        return Icon(Icons.stop, size: 50);
      case AudioState.recording:
        return Icon(Icons.mic, color: Colors.redAccent, size: 50);
      default:
        return Icon(Icons.mic, size: 50);
    }
  }
}

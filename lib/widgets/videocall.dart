import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

class Videocall extends StatefulWidget {
  const Videocall({Key? key}) : super(key: key);

  @override
  _VideocallState createState() => _VideocallState();
}

class _VideocallState extends State<Videocall> {
  final AgoraClient _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: '972d9195d68c4aa59e66079ee410d8e6',
          channelName: 'CHANNELMS',
          tempToken:
              '006972d9195d68c4aa59e66079ee410d8e6IABtbTK897fiJ+KqMh/SoApIp3XSc32d/oCmZy6xJyCCq2DsfKkAAAAAEABUm4+sUGenYgEAAQBPZ6di'));

  @override
  void initState() {
    _initAgora();
    super.initState();
  }

  Future _initAgora() async {
    await _client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        AgoraVideoViewer(
          client: _client,
          layoutType: Layout.floating,
        ),
        AgoraVideoButtons(
          client: _client,
          enabledButtons: [
            BuiltInButtons.toggleCamera,
            BuiltInButtons.callEnd,
            BuiltInButtons.toggleMic,
          ],
        )
      ],
    ));
  }
}

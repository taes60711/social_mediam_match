import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../service/fb_service.dart';
import 'package:just_audio/just_audio.dart';

// Feed your own stream of bytes into the player
class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    FbService fireBaseService = FbService();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                fireBaseService.signOut();
                Navigator.of(context).popUntil((route) => route.settings.name == "/");
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("登出"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.exit_to_app),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              print("audio player");
              // 加载资产文件的字节数据
              ByteData byteData = await rootBundle.load('assets/masion.mp3');
              Uint8List bytes = await byteData.buffer.asUint8List();

              AudioPlayer _audioPlayer = AudioPlayer();

              await _audioPlayer.setAudioSource(MyCustomSource(bytes));

              _audioPlayer.play();
            },
            child: Container(
              width: 100,
              height: 50,
              color: Colors.lime,
              child: Center(
                child: Text("Audio Player"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

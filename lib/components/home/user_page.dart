import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/io.dart';
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

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  IOWebSocketChannel voiceChannel = IOWebSocketChannel.connect('ws://114.37.157.2:80/ws/voice');
  String s = "";
  void initState() {
    super.initState();
    // _initializeConnection();
  }

  void _initializeConnection() async {
    await voiceChannel.ready;
    ByteData byteData = await rootBundle.load('assets/masion.mp3');
    Uint8List bytes = byteData.buffer.asUint8List();
    String base64String = base64Encode(bytes);
    print(base64String.length);

    int chunkSize = 8000;
    List<String> chunks = [];
    for (int i = 0; i < base64String.length; i += chunkSize) {
      int end = (i + chunkSize < base64String.length) ? i + chunkSize : base64String.length;
      String chunk = base64String.substring(i, end);
      chunks.add(chunk);
      voiceChannel.sink.add(chunk);
    }

    voiceChannel.stream.listen((event) {
      print("server Message:" + event);
      s += event;
    });
  }

  @override
  Widget build(BuildContext context) {
    FbService fireBaseService = FbService();

    final record = AudioRecorder();
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

              print(s.length);
              Uint8List bytes = base64Decode(s);
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
          GestureDetector(
            onTap: () async {
              AudioPlayer _audioPlayer = AudioPlayer();

              try {
                if (await record.hasPermission()) {
                  print("Audio Recoder");
                  FlutterSoundRecorder _recorder = FlutterSoundRecorder();

                  final status = await Permission.microphone.request();
                  if (status.isGranted) {
                    final stream = await record.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
                    stream.listen((event) async {
                      print(event);
                      String base64String = base64Encode(event);
                      s += base64String;
                    });
                  }
                }
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              width: 100,
              height: 50,
              color: Colors.lime,
              child: Center(
                child: Text("Audio Recoder"),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              record.dispose();
            },
            child: Container(
              width: 100,
              height: 50,
              color: Colors.lime,
              child: Center(
                child: Text("Recoder close"),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final FlutterSoundPlayer _player = FlutterSoundPlayer();

              await _player.openPlayer();
              await _player.startPlayer(
                  fromDataBuffer: base64Decode(s),
                  codec: Codec.pcm16,
                  numChannels: 1,
                  sampleRate: 44100,
                  whenFinished: () {
                    print("finished");
                  });
            },
            child: Container(
              width: 100,
              height: 50,
              color: Colors.lime,
              child: Center(
                child: Text("RecodedAudio play"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

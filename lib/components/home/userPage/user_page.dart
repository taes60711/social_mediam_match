// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:web_socket_channel/io.dart';
// import '../../service/fb_service.dart';
// import 'package:just_audio/just_audio.dart';

// // Feed your own stream of bytes into the player
// class MyCustomSource extends StreamAudioSource {
//   final List<int> bytes;
//   MyCustomSource(this.bytes);

//   @override
//   Future<StreamAudioResponse> request([int? start, int? end]) async {
//     start ??= 0;
//     end ??= bytes.length;
//     return StreamAudioResponse(
//       sourceLength: bytes.length,
//       contentLength: end - start,
//       offset: start,
//       stream: Stream.value(bytes.sublist(start, end)),
//       contentType: 'audio/mpeg',
//     );
//   }
// }

// class UserPage extends StatefulWidget {
//   const UserPage({super.key});

//   @override
//   State<UserPage> createState() => _UserPageState();
// }

// class _UserPageState extends State<UserPage> {
//   IOWebSocketChannel voiceChannel = IOWebSocketChannel.connect('ws://114.37.157.2:80/ws/voice');
//   String s = "";
//   void initState() {
//     super.initState();
//     // _initializeConnection();
//   }

//   void _initializeConnection() async {
//     await voiceChannel.ready;
//     ByteData byteData = await rootBundle.load('assets/masion.mp3');
//     Uint8List bytes = byteData.buffer.asUint8List();
//     String base64String = base64Encode(bytes);
//     print(base64String.length);

//     int chunkSize = 8000;
//     List<String> chunks = [];
//     for (int i = 0; i < base64String.length; i += chunkSize) {
//       int end = (i + chunkSize < base64String.length) ? i + chunkSize : base64String.length;
//       String chunk = base64String.substring(i, end);
//       chunks.add(chunk);
//       voiceChannel.sink.add(chunk);
//     }

//     voiceChannel.stream.listen((event) {
//       print("server Message:" + event);
//       s += event;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     FbService fireBaseService = FbService();

//     final record = AudioRecorder();
//     return SafeArea(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 fireBaseService.signOut();
//               },
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text("登出"),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Icon(Icons.exit_to_app),
//                 ],
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               print("audio player");

//               print(s.length);
//               Uint8List bytes = base64Decode(s);
//               AudioPlayer _audioPlayer = AudioPlayer();

//               await _audioPlayer.setAudioSource(MyCustomSource(bytes));

//               _audioPlayer.play();
//             },
//             child: Container(
//               width: 100,
//               height: 50,
//               color: Colors.lime,
//               child: Center(
//                 child: Text("Audio Player"),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               AudioPlayer _audioPlayer = AudioPlayer();

//               try {
//                 if (await record.hasPermission()) {
//                   print("Audio Recoder");
//                   FlutterSoundRecorder _recorder = FlutterSoundRecorder();

//                   final status = await Permission.microphone.request();
//                   if (status.isGranted) {
//                     final stream = await record.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
//                     stream.listen((event) async {
//                       print(event);
//                       String base64String = base64Encode(event);
//                       s += base64String;
//                     });
//                   }
//                 }
//               } catch (e) {
//                 print(e);
//               }
//             },
//             child: Container(
//               width: 100,
//               height: 50,
//               color: Colors.lime,
//               child: Center(
//                 child: Text("Audio Recoder"),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               record.dispose();
//             },
//             child: Container(
//               width: 100,
//               height: 50,
//               color: Colors.lime,
//               child: Center(
//                 child: Text("Recoder close"),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               final FlutterSoundPlayer _player = FlutterSoundPlayer();

//               await _player.openPlayer();
//               await _player.startPlayer(
//                   fromDataBuffer: base64Decode(s),
//                   codec: Codec.pcm16,
//                   numChannels: 1,
//                   sampleRate: 44100,
//                   whenFinished: () {
//                     print("finished");
//                   });
//             },
//             child: Container(
//               width: 100,
//               height: 50,
//               color: Colors.lime,
//               child: Center(
//                 child: Text("RecodedAudio play"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/require_login.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../../global.dart';
import '../../strings/userPage/user_page_string.dart';

class UserPage extends StatelessWidget {
  final LoginUser? userData;
  const UserPage({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    bool isLoading = context.select((UserState value) => value.isLoading);
    Widget userComponent;

    if (isLoading) {
      userComponent = const Loading();
    } else {
      if (userData != null) {
        LoginUser realUserData = userData!;
        userComponent = SizedBox(
          width: ScreenSize().width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () async {
                    userFuture.signOut();
                  },
                  child: Text(signOutButton),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.green,
                ),
              ),
              Text("Hello, ${realUserData.name ?? realUserData.email}"),
              Row(
                children: [
                  SizedBox(
                    width: ScreenSize().width / 2,
                    child: Column(
                      children: [
                        Text(skillText),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: realUserData.mainSkills!.map((e) => Text("${e.name} , ")).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: ScreenSize().width / 2,
                    child: Column(
                      children: [
                        Text(wantSkillText),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: realUserData.wantSkills!.map((e) => Text("${e.name} , ")).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: ManagerButton.values
                    .map((e) => ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pushNamed(
                              RoutePath.profilePage.value,
                              arguments: realUserData,
                            );
                          },
                          child: Text(e.value),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      } else {
        userComponent = const requireLogin();
      }
    }

    return Scaffold(body: userComponent);
  }
}

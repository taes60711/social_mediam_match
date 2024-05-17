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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../../states/friend_state.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/skill_list_view.dart';
import '../../utilities/style/screen_size.dart';

class SettingButtonInfo {
  String title;
  IconData icon;
  VoidCallback onPress;
  SettingButtonInfo({required this.title, required this.icon, required this.onPress});
}

class UserPage extends StatelessWidget {
  final LoginUser userData;
  final FriendState friendState;
  final VoidCallback gotoFriendPage;
  const UserPage({super.key, required this.userData, required this.friendState, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    List<SettingButtonInfo> settingButtonInfoList = [
      SettingButtonInfo(
          title: UserPageString().profileBtn,
          icon: FontAwesomeIcons.solidAddressCard,
          onPress: () {
            Navigator.of(context).pushNamed(
              RoutePath.profilePage.value,
              arguments: userData,
            );
          }),
      SettingButtonInfo(
          title: UserPageString().postBtn,
          icon: FontAwesomeIcons.solidNewspaper,
          onPress: () {
            Navigator.of(context).pushNamed(
              RoutePath.myPosts.value,
              arguments: {
                "userData": userData,
                "gotoFriendPage": gotoFriendPage,
              },
            );
          }),
      SettingButtonInfo(
          title: UserPageString().courseBtn,
          icon: FontAwesomeIcons.school,
          onPress: () {
            print("${UserPageString().courseBtn}");
            Navigator.of(context).pushNamed(RoutePath.myCourses.value, arguments: {
              "userData": userData,
            });
          }),
      SettingButtonInfo(
          title: UserPageString().settingBtn,
          icon: FontAwesomeIcons.gear,
          onPress: () {
            print("${UserPageString().settingBtn}");
            Navigator.of(context).pushNamed(RoutePath.privacySettingPage.value, arguments: {
              "userData": userData,
              "friendState": friendState,
            });
          }),
    ];

    List<SettingButtonInfo> settingButtonInfoList2 = [
      SettingButtonInfo(
          title: UserPageString().friendManagernBtn,
          icon: FontAwesomeIcons.userLarge,
          onPress: () {
            print("${UserPageString().friendManagernBtn}");
          }),
      SettingButtonInfo(
          title: UserPageString().notificationBtn,
          icon: FontAwesomeIcons.solidBell,
          onPress: () {
            print("${UserPageString().notificationBtn}");
          }),
      SettingButtonInfo(
          title: UserPageString().guideBtn,
          icon: Icons.question_answer,
          onPress: () {
            print("${UserPageString().guideBtn}");
          }),
    ];

    return BackgroundWidget(
      child: Column(
        children: [
          SizedBox(
            height: ScreenSize().safeheight * 0.05,
          ),
          SizedBox(
            width: ScreenSize().width,
            height: ScreenSize().safeheight * 0.3,
            child: FittedBox(
              child: Column(
                children: [
                  UserIcon(iconSize: 100, image: userData.image),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text("Hello, ${userData.name ?? userData.email}"),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: hintTextColor.withAlpha(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${UserPageString().infoStatus} : ${userData.status}"),
                        Text("${UserPageString().infoJob} : ${userData.job}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: ScreenSize().width,
            height: ScreenSize().safeheight * 0.6,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //持っているスキル
                    Text(StepTwoPage().haveSkillText),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      width: ScreenSize().width,
                      child: SkillListView(
                        skillList: userData.mainSkills ?? [],
                        backgroundColor: googleColor,
                      ),
                    ),
                    //勉強したいスキル
                    Text(StepTwoPage().wantSkillText),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      width: ScreenSize().width,
                      child: SkillListView(
                        skillList: userData.wantSkills ?? [],
                        backgroundColor: googleColor,
                      ),
                    ),
                    //設定ボタン　例：プロフィール、設定、ニュース...
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: normalBgColor2),
                        borderRadius: BorderRadius.circular(10),
                        color: hintTextColor.withAlpha(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: settingButtonInfoList
                                .map(
                                  (e) => SizedBox(
                                    width: ScreenSize().width / 4,
                                    child: CustomButton(
                                        title: e.title,
                                        icon: e.icon,
                                        titleColor: normalBgColor2,
                                        backgroundColor: normalBgColor,
                                        onPress: e.onPress),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: settingButtonInfoList2
                                .map(
                                  (e) => SizedBox(
                                    width: ScreenSize().width / 4,
                                    child: CustomButton(
                                        title: e.title,
                                        icon: e.icon,
                                        titleColor: normalBgColor2,
                                        backgroundColor: normalBgColor,
                                        onPress: e.onPress),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

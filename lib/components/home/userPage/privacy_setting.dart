import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/rich_text_view.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/rich_text_format.dart';
import '../../../states/services/notification_service.dart';
import '../../../states/user_state.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/style/screen_size.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

String imgUrl = 'https://user-images.githubusercontent.com/122956/72955931-ccc07900-3d52-11ea-89b1-d468a6e2aa2b.png';
String youtubeUrl = 'https://www.youtube.com/embed/pje9RbHP_sA';
String url = "http://$ip:$port";
// class PrivacySetting extends StatelessWidget {
//   const PrivacySetting({super.key});

//   @override
//   Widget build(BuildContext context) {
//     UserState userFuture = context.read<UserState>();
//     FriendState friendState = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['friendState'];

//     return Scaffold(
//       body: SafeArea(
//         child: SizedBox(
//           width: ScreenSize().width,
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
//                   },
//                   icon: const Icon(Icons.arrow_back_ios),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   NotificationService().sendNotification(
//                       message: "消息",
//                       sendto:
//                           "c-K6UQ-LSlS44Ymc6H1cJh:APA91bH1SHXOOWIj3xW1KYWAOB4V5PTu9L0Yd0pqZ1qYtl99EhbmVsdY0ESgco7pwYYS0RLDCCXHHATGqmPXUPAHxAfeJngw7nuQ1ml92rx0ORueiZR8ofS8Yd1xDVmlJ6KGvkVyKfwJ");
//                 },
//                 child: Text("送通知(還沒完善)"),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await userFuture.signOut(friendState);
//                   Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
//                 },
//                 child: Text(signOutButton),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class PrivacySetting extends StatefulWidget {
  const PrivacySetting({super.key});

  @override
  State<PrivacySetting> createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
  @override
  Widget build(BuildContext context) {
    String s =
        '<p><span style="color: rgb(255, 235, 59);">51121</span>   23   13.<span class="ql-size-large" style="background-color: rgb(0, 150, 136);">    Hh</span></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/uE_T_t6s_Go"></iframe><p><span class="ql-size-large" style="background-color: rgb(0, 150, 136);">ffgh</span></p><p><img src="https://images.chinatimes.com/newsphoto/2024-04-03/1024/20240403005728.jpg"></p><p><a href="https://forum.gamer.com.tw" rel="noopener noreferrer" target="_blank" style="color: rgb(63, 81, 181);">Launcher URL</a></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/ceJhXI6LwjE"></iframe><p><br></p>';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  RichTextEditor(content: s),
                  RichTextView(content: s),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}

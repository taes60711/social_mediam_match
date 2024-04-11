import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
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
  Future<void> imageView(String imgUrl) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dismissible(
          direction: DismissDirection.vertical,
          onDismissed: (_) => Navigator.of(context).pop(),
          key: const Key('key'),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PhotoView(
                    imageProvider: NetworkImage(imgUrl),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String choicedImg = "";
  @override
  Widget build(BuildContext context) {
    dynamic jsonList = jsonEncode([
      {"insert": r'hello\n'},
      {
        "insert": {"image": "https://user-images.githubusercontent.com/122956/72955931-ccc07900-3d52-11ea-89b1-d468a6e2aa2b.png"},
        "attributes": {"style": "height : 150px"}
      },
      {
        "insert": {"image": "https://images.chinatimes.com/newsphoto/2024-04-03/1024/20240403005728.jpg"},
      },
      {
        "insert": {"url": "https://forum.gamer.com.tw"},
        "attributes": {"link": "https://forum.gamer.com.tw"}
      },
      {
        "insert": {"video": "https://www.youtube.com/embed/ceJhXI6LwjE"}
      },
      {
        "insert": {"video": "https://drive.google.com/file/d/1eaCBt5aCl8tsT8BwEuSqfwgMMcybybjX/preview"}
      }
    ]);

    String jsonString =
        '[{"insert":"hello\\n"},{"insert":{"image":"https://user-images.githubusercontent.com/122956/72955931-ccc07900-3d52-11ea-89b1-d468a6e2aa2b.png"},"attributes":{"style":"height : 150px"}},{"insert":{"image":"https://images.chinatimes.com/newsphoto/2024-04-03/1024/20240403005728.jpg"}},{"insert":{"url":"Launcher"},"attributes": {"link": "https://forum.gamer.com.tw"}},{"insert":{"video":"https://www.youtube.com/embed/pje9RbHP_sA"}},{"insert":{"video":"https://drive.google.com/file/d/1eaCBt5aCl8tsT8BwEuSqfwgMMcybybjX/preview"}}]';
    List<dynamic> mapJson = jsonDecode(jsonList);

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
                  HtmlWidget(
                    RichTextFormat(jsonString: jsonString).toHtmlString(),
                    onTapUrl: (url) {
                      print("click: $url");
                      final Uri _url = Uri.parse(url);
                      launchUrl(_url);
                      return false;
                    },
                    onTapImage: (src) {
                      inspect(src);
                      setState(() {
                        choicedImg = src.sources.first.url;
                      });
                      imageView(choicedImg);
                    },
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}

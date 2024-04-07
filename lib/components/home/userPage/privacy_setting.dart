import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../states/services/notification_service.dart';
import '../../../states/user_state.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/style/screen_size.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

String imgUrl = 'https://user-images.githubusercontent.com/122956/72955931-ccc07900-3d52-11ea-89b1-d468a6e2aa2b.png';
String youtubeUrl = 'https://www.youtube.com/embed/pje9RbHP_sA';

class PrivacySetting extends StatelessWidget {
  const PrivacySetting({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    FriendState friendState = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['friendState'];

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: ScreenSize().width,
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
              ElevatedButton(
                onPressed: () {
                  NotificationService().sendNotification(
                      message: "消息",
                      sendto:
                          "c-K6UQ-LSlS44Ymc6H1cJh:APA91bH1SHXOOWIj3xW1KYWAOB4V5PTu9L0Yd0pqZ1qYtl99EhbmVsdY0ESgco7pwYYS0RLDCCXHHATGqmPXUPAHxAfeJngw7nuQ1ml92rx0ORueiZR8ofS8Yd1xDVmlJ6KGvkVyKfwJ");
                },
                child: Text("送通知(還沒完善)"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await userFuture.signOut(friendState);
                  Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                },
                child: Text(signOutButton),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: HtmlWidget(
                    '''
                      <h3>Heading</h3>
                      <p>
                        A paragraph with <strong>strong</strong>, <em>emphasized</em>
                        and <span style="color: red">colored</span> text.
                      </p>
                      <a href="https://forum.gamer.com.tw">Launch URL</a>
                      <img src=$imgUrl  height='150'>
                      <iframe src=$youtubeUrl></iframe>
                    ''',
                    onTapUrl: (url) {
                      print("click: $url");
                      final Uri _url = Uri.parse(url);
                      launchUrl(_url);
                      return false;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

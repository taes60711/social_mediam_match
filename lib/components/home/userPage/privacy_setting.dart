import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/services/dynamic_links.dart';
import '../../../provider/account/user_state.dart';
import '../../../states/services/notification_service.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/style/screen_size.dart';

class PrivacySetting extends StatelessWidget {
  const PrivacySetting({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userFuture = context.read<UserProvider>();
    FriendState friendState = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['friendState'];

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: ScreenSize.width,
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
                  String createdLink = await DynamicLinks().createLink("refCode");
                  print(createdLink);
                },
                child: Text("DynamicLink(Test)"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await userFuture.signOut(friendState);
                  Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                },
                child: Text(signOutButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

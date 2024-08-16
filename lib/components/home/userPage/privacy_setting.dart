import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import '../../../provider/account/user_provider.dart';

import '../../../provider/friend_provider.dart';
import '../../../services/dynamic_links.dart';
import '../../../services/notification_service.dart';
import '../../strings/userPage/user_page_string.dart';
import '../../utilities/style/screen_size.dart';

class PrivacySetting extends StatelessWidget {
  const PrivacySetting({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userFuture = context.read<UserProvider>();
    FriendProvider friendProvider = context.read<FriendProvider>();

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
                    RouteOptions.popUntilToHome();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  NotificationService().sendNotification(
                    title: "title",
                    message: "消息",
                    sendto:
                        "ehcRrRfgQp6EyWYXCHAYYU:APA91bHeteDmLx9QVu3yOqhhtlODyZTRVATAPJCQoDgCXh_l_LKKODmERLb750uIMdB4tJzR43bfYHotVFpVlcQIKcIM3hA3-txTnfrjU84amHOHzRIrN2SQZs0Mepf8ss-n_g9mKbG5",
                  );
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
                  await userFuture.signOut(friendProvider);
                  RouteOptions.popUntilToHome();
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

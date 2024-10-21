import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import '../../../models/notification_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';

import '../../../provider/friend_provider.dart';
import '../../../services/dynamic_links.dart';

import '../../../services/firebase_notification_service.dart';
import '../../strings/userPage/user_page_string.dart';

import '../../utilities/style/screen_size.dart';
import '../../utilities/style/theme_style.dart';

class PrivacySetting extends StatefulWidget {
  const PrivacySetting({super.key});

  @override
  State<PrivacySetting> createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        NotificationModel notification = NotificationModel(
                          id: -1,
                          userUid: 'tzLaMcP3V9XOAMOcD0FAY5Nf4tE2',
                          otherUserUid: 'ACqYscxtd2VSdPlkv1G8OgSTKxd2',
                          type: 0,
                          title: '"12135"對文章"1"按讚',
                          isRead: false,
                          message: '',
                          postId: 1,
                          postTime: DateTime.now(),
                          sendNotificationuserInfo: LoginUser(),
                        );

                        FirebaseNotificationService().sendNotification(
                            message: '"12135"對文章"1"按讚',
                            sendto:
                                "ehcRrRfgQp6EyWYXCHAYYU:APA91bHeteDmLx9QVu3yOqhhtlODyZTRVATAPJCQoDgCXh_l_LKKODmERLb750uIMdB4tJzR43bfYHotVFpVlcQIKcIM3hA3-txTnfrjU84amHOHzRIrN2SQZs0Mepf8ss-n_g9mKbG5",
                            notifiactionInfo: notification);
                        // NotificationService().createNotification(notification: notification);
                      },
                      child: Text("cre post"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        NotificationModel notification = NotificationModel(
                          id: -1,
                          userUid: 'tzLaMcP3V9XOAMOcD0FAY5Nf4tE2',
                          otherUserUid: 'Fx0NZUwhLGNuDhaz1ZdyT2vyq3z1',
                          type: 1,
                          title: '"20240324@gmail.com"申請想要觀看課程"123456"',
                          isRead: false,
                          message: '',
                          courseId: 19,
                          postTime: DateTime.now(),
                          sendNotificationuserInfo: LoginUser(),
                        );
                        FirebaseNotificationService().sendNotification(
                            message: '"20240324@gmail.com"申請想要觀看課程"123456"',
                            sendto:
                                "ehcRrRfgQp6EyWYXCHAYYU:APA91bHeteDmLx9QVu3yOqhhtlODyZTRVATAPJCQoDgCXh_l_LKKODmERLb750uIMdB4tJzR43bfYHotVFpVlcQIKcIM3hA3-txTnfrjU84amHOHzRIrN2SQZs0Mepf8ss-n_g9mKbG5",
                            notifiactionInfo: notification);
                        // NotificationService().createNotification(notification: notification);
                      },
                      child: Text("cre cour"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        NotificationModel notification = NotificationModel(
                          id: -1,
                          userUid: 'tzLaMcP3V9XOAMOcD0FAY5Nf4tE2',
                          otherUserUid: 'kTmSC7QNzoc1pf2jWd4sFOAr6q02',
                          type: 2,
                          title: '"555"將你加為好友',
                          isRead: false,
                          message: '',
                          postTime: DateTime.now(),
                          sendNotificationuserInfo: LoginUser(),
                        );
                        FirebaseNotificationService().sendNotification(
                            message: '"555"將你加為好友',
                            sendto:
                                "ehcRrRfgQp6EyWYXCHAYYU:APA91bHeteDmLx9QVu3yOqhhtlODyZTRVATAPJCQoDgCXh_l_LKKODmERLb750uIMdB4tJzR43bfYHotVFpVlcQIKcIM3hA3-txTnfrjU84amHOHzRIrN2SQZs0Mepf8ss-n_g9mKbG5",
                            notifiactionInfo: notification);
                        // NotificationService().createNotification(notification: notification);
                      },
                      child: Text("add fri"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        NotificationModel notification = NotificationModel(
                          id: -1,
                          userUid: 'tzLaMcP3V9XOAMOcD0FAY5Nf4tE2',
                          otherUserUid: 'kTmSC7QNzoc1pf2jWd4sFOAr6q02',
                          type: 3,
                          title: '"555"將你加為好友',
                          roomId: 19,
                          isRead: false,
                          message: '',
                          postTime: DateTime.now(),
                          sendNotificationuserInfo: LoginUser(),
                        );
                        FirebaseNotificationService().sendNotification(
                            title: "kTmSC7QNzoc1pf2jWd4sFOAr6q02",
                            message: '文字訊息',
                            sendto:
                                "ehcRrRfgQp6EyWYXCHAYYU:APA91bHeteDmLx9QVu3yOqhhtlODyZTRVATAPJCQoDgCXh_l_LKKODmERLb750uIMdB4tJzR43bfYHotVFpVlcQIKcIM3hA3-txTnfrjU84amHOHzRIrN2SQZs0Mepf8ss-n_g9mKbG5",
                            notifiactionInfo: notification);
                      },
                      child: Text("sen msg"),
                    ),
                  )
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ThemeStyle().onChangeTeme(AppThemeType.black);
                      setState(() {});
                    },
                    child: Text("black"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ThemeStyle().onChangeTeme(AppThemeType.white);
                      setState(() {});
                    },
                    child: Text("white"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FirebaseNotificationService notificationService = FirebaseNotificationService();
  if (message.notification != null) {
    notificationService.showNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
    print("Handling a background message: ${message.messageId}");
    inspect(message);
  }
}

class FirebaseNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  String fcmKey =
      "AAAA1oDv9EA:APA91bHr7jR2YPWA6jvt4V1NI3wIsLAV8OXy_fLDlgeiU_K9wkxijMbt3-6Ax6OB11ky-xDT0CScwuZVgV8a8S9BK0xEJBUlB7DL8NnkMI6r4QSX6jq-5cIpTMR0eW2eESmJqqurbOYE";

  Future<void> sendNotification({String? title, String? message, required String sendto}) async {
    final uri = Uri.parse(fcmUrl);

    Map<String, String> headers = {'content-type': 'application/json', 'Authorization': 'key=$fcmKey'};
    String body = jsonEncode({
      "notification": {"title": title ?? "Social Medaiam Match", "body": message ?? ""},
      "priority": "high",
      "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
      "to": sendto
    });

    await http.post(uri, headers: headers, body: body).then((_) {
      print("sendNotification :${_.body}");
    });
  }

  Future<void> notificationListen() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('通知权限已拒绝');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground:');
        inspect(message);

        if (message.notification != null) {
          showNotification(
            title: message.notification?.title,
            body: message.notification?.body,
          );
        }
      });
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      print('通知权限已授权');
    }
  }

  Future<void> initNotification(BuildContext context) async {
    print("initNotification 通知初始化");
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('flutter_logo');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // await Future.delayed(Duration(seconds: 2));
        // context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.chatRoom);
        // context.read<FriendProvider>().openRoom(13, context.read<UserProvider>().userData);
        // openChatRoomEndDrawer(context: context);
        // RouteOptions.pushTo(RoutePath.profilePage);
      },
    );
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "channel.id",
        "channel.name",
        importance: Importance.high,
      ),
    );
  }

  Future showNotification({int id = 0, String? title, String? body}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }
}

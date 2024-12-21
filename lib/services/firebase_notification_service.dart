// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:social_mediam_match/components/home/firendsPage/chat_room.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';

import 'package:social_mediam_match/global/home_global_view_model.dart';
import 'package:social_mediam_match/models/notification_model.dart';
import 'package:social_mediam_match/pageManager/enum/bottom_bar_path.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../components/home/userPage/my_notification_page/course/my_notification_course_page.dart';
import '../components/home/userPage/my_notification_page/my_notification_post_page.dart';
import '../models/course_model.dart';
import '../models/friend_model.dart';
import '../models/post_model.dart';
import 'course_service.dart';
import 'post_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FirebaseNotificationService notificationService = FirebaseNotificationService();
  if (message.notification != null) {
    notificationService.showNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      payload: message.data['notifiactionInfo'],
    );
    print("Handling a background message: ${message.messageId}");

    inspect(message);
  }
}

class FirebaseNotificationService {
  late BuildContext context;
  late WidgetRef ref;

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> notificationListen({required BuildContext context, required WidgetRef ref}) async {
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
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('Got a message whilst in the foreground: ${message.data['notifiactionInfo']}  ');
        NotificationModel receviceNotificaionData = NotificationModel.receviceDatatoModel(message.data['notifiactionInfo'] ?? "");

        print(receviceNotificaionData);
        inspect(message);

        if (message.notification != null) {
          if (receviceNotificaionData.type == 3) {
            ///チャットルーム
            if (ref.read(loginUserInChatRoomId.notifier).state == receviceNotificaionData.roomId) {
              return;
            }
          } else {
            await Future.delayed(Duration.zero);
            int notReadCount = ref.read(loginUserNotReadNotificationCount.notifier).state;
            notReadCount++;
            ref.read(loginUserNotReadNotificationCount.notifier).update((e) => notReadCount);
          }

          showNotification(
            title: message.notification?.title,
            body: message.notification?.body,
            payload: message.data['notifiactionInfo'],
          );
        }
      });
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      print('通知权限已授权');
    }
  }

  Future<void> initNotification({required BuildContext context, required WidgetRef ref}) async {
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
        NotificationModel receviceNotificaionData = NotificationModel.receviceDatatoModel(notificationResponse.payload ?? "");

        await Future.delayed(Duration.zero);
        if (receviceNotificaionData.type == 0) {
          ///文章
          HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.home);
          PostModel choicedPost = await PostService().getPostDataByPostId(receviceNotificaionData.postId ?? -1);
          MyNotificationPostPage(data: choicedPost).show(context);
        } else if (receviceNotificaionData.type == 1) {
          ///コース
          HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.course);

          CourseModel openedCourse = await CourseService().getCourseBycourseId(
            ref.read(loginUserData).uid,
            receviceNotificaionData.courseId ?? -1,
          );
          MyNotificationCourseDetailPage(data: openedCourse).show(context);
        } else if (receviceNotificaionData.type == 2 || receviceNotificaionData.type == 3) {
          ///チャットルーム
          if (receviceNotificaionData.type == 3) {
            if (ref.read(loginUserInChatRoomId.notifier).state == receviceNotificaionData.roomId) {
              return;
            }
          }

          ///友達追加 / チャットルーム
          HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.chatRoom);
          int index = ref.watch(frinedListProvider).indexWhere((e) => e.roomId == receviceNotificaionData.roomId);
          if (index != -1) {
            FriendListModel data = ref.watch(frinedListProvider)[index];
            ChatRoom(roomData: data, dataIndex: index).show(context);
          }
        }
      },
    );
  }

  Future<void> sendNotification({
    String title = "SkillStorm",
    String message = "",
    required String sendto,
    required NotificationModel notifiactionInfo,
  }) async {
    String fcmUrl = 'https://fcm.googleapis.com/v1/projects/socialmediammatch/messages:send';

    print(sendto);
    String body = jsonEncode(
      {
        'message': {
          "token": sendto,
          "notification": {
            "title": title,
            "body": message,
          },
          "data": {
            "notifiactionInfo": NotificationModel.receviceDataToJson(notifiactionInfo),
          },
        }
      },
    );

    final uri = Uri.parse(fcmUrl);
    final String serverToken = await getServerAccessToken();

    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $serverToken',
    };

    await http.post(uri, headers: headers, body: body).then((value) {
      print("sendNotification :${value.body}");
    });
  }

  static Future<String> getServerAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "socialmediammatch",
      "private_key_id": "01d06908bc4ff0368a136641a3cc8904176ad560",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4jQEB3mWyhmU6\n09xcA2llvtwatpue1uqkMElzJtTrCNDctxLD1SzSdpfObHA0CCspiuuTfONsNmYS\nzEXfuLeFCUx5CfmeWaKpMQIaTtCnKASzdQOiAClo87KgoIav8ABZZrYiaVgOS2Xu\n1f95of0fi2Y4y/5Blu2nz97+n4r01ZW/RLVbwOaYFZeAHg/0RDKJwbbR0jOdj+Ii\n+otKVTjdeG11hEW5eiIq6rlICyX0NUkaCKlKBCU7rMHK7yXG7WUYn6+5O7xavBBr\nvQh8txiAwJ6uB76cXV94ySVk6oNq71cEqaYkfYlc74hrUihY6lsrqRi6NAYKH2il\nTrcbIeXFAgMBAAECggEAAsTgLlOp7vh5QwgJbGVYtYAcSVeoFMVgwT9AOuFq8cPb\nbmmzdwtsdWlLdHtytjUmgKRm+HrikVhs8PyY/SGxDzvz0R/HMQsN7RVL1MfjSuly\nI0cu23AT2aaebYPlwXS2bKD6kUryA/TkU1BpWZKGpmyEXMx4GiqA57MEw4lH9SMg\nrsavDAJc5SuJJ0SWDOBNv4lC0XZjX2SWTH/oe0KliZQaLcAf0u/jm5l7S2EG3A4Y\nGzx5dEf28lm2Ol/Np0toK0u/2TaY5gejf5GYGtoV0algy0BOn25rsD/OlHi8qQJY\nlEclyuhvlOXfR0MvSbogyfCpomQzh6NsSTkJ8iXCwQKBgQD7KvEx9u0WK7fK2Ium\nwucFdcDwoah9GZfeDjGOGoujc3Pu4C2XmKXazI9BVhdMz+0FEF/gUH9DaE8/D4Ew\nJ5SkRX7Kit6OZue9UqdCUPhuAWQBS6+8qpJEid+uf5LAeSVDm2JgwXZ004YHxg2U\n/uUbZeDvGWXJboRPF8N/80eAKQKBgQC8GfVRDgcgNWjSsYhZMRkm3ybdbigbaRPd\nnX74iyIQlSdxbmHmFcvOW3hkzZhSASYIVYbvTuNTbMs5Ht7weho86QSnfZCGIYJa\nmAUGGR/brkIdewy3NWIoS+XHAfwARusoxSmS9BBTMQn/viPNmpAixTr/AVjuX9Oz\nKIjUF3D8PQKBgQCICXIpxbwTzgn16+N3pwjJhEXED0ratwnyU22zsdz/4oBgWTtY\naG0sXK8ajC6Cg/u0SnIjZHYJZG3HkfY+xrFTZ/CMczqnlkTd3e6JlKF5s3ce3IeK\ngDhItwRX1vD9HqB4Rai7Dw3BqO9nNnYUxRoCBOQXnIHs39b5n71bh8CqQQKBgELW\nWnPVrzSDpd6P1KoUpyJH0rCFrtymhreNegtorM8FoMFOfpzaC9QkbnArGb+xxsjZ\nUxv/hQkktEV0sbTzPhV8mvnExTDUAVSdhdN34/kUP0voaElFP76f0WLYUqnqiS6w\neChObuqQl0P3VRN+o06nlGH+IZJ6HGghtBTgy3XlAoGAG7Mu5ZcQP+x5imWUZacN\nUGTIrngHLJh80ahbR4/haui7eI9AQcFtoaqi8hK2GK3KEhZcqL7Tm1O/3y9F1cPr\nBw4DkGmN2UMpDtwSqJ7Je/q2kVDufbB+KfdS3UwEGd8uHAC/gqptU7S4wHtumn/Q\nU8vKfX6cKyWlC30GeO/e93A=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-bj7eu@socialmediammatch.iam.gserviceaccount.com",
      "client_id": "106314873486609910684",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-bj7eu%40socialmediammatch.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Get Access Token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes, client);
    client.close();

    return credentials.accessToken.data;
  }

  Future showNotification({int id = 0, String? title, String? body, String payload = "payload"}) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel.id",
          "channel.name",
          importance: Importance.high,
        ),
      ),
      payload: payload,
    );
  }
}

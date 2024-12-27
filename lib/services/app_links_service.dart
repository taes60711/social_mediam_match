// ignore_for_file: avoid_print

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/user_profile_bottom_sheet.dart';
import 'package:social_mediam_match/services/user_service.dart';

import '../components/home/userPage/my_notification_page/course/my_notification_course_page.dart';
import '../components/home/userPage/my_notification_page/my_notification_post_page.dart';
import '../global/home_global_view_model.dart';
import '../global/user_login_status_controller.dart';
import '../models/course_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../pageManager/enum/bottom_bar_path.dart';
import '../provider/account/user_provider.dart';
import 'course_service.dart';
import 'post_service.dart';

class AppLinkService {
  final appLinks = AppLinks();
  late BuildContext context;
  late WidgetRef ref;

  Future<void> init({required BuildContext context, required WidgetRef ref}) async {
    try {
      this.context = context;
      this.ref = ref;
      Uri? uri = await appLinks.getInitialLink();

      print("AppLinks Init");
      if (uri != null) {
        runShareUrl(uri);
      }

      applinkListen();
    } catch (e) {
      print(e);
    }
  }

  void applinkListen() {
    appLinks.uriLinkStream.listen((event) {
      runShareUrl(event);
    });
  }

  void applinkStop() {}

  Future<void> runShareUrl(Uri url) async {
    Map<String, String>? mappedData = parseUrl("$url");
    if (mappedData != null) {
      String type = mappedData["type"] ?? "";
      String content = mappedData["content"] ?? "";

      switch (type) {
        case "post":
          if (UserLoginStatusController().isLogin()) {
            ///文章
            HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.home);
            PostModel choicedPost = await PostService().getPostDataByPostId(int.parse(content));
            MyNotificationPostPage(data: choicedPost).show(context);
          }
          break;
        case "course":
          if (UserLoginStatusController().isLogin()) {
            ///コース
            HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.course);

            CourseModel openedCourse = await CourseService().getCourseBycourseId(
              ref.read(loginUserData).uid,
              int.parse(content),
            );
            MyNotificationCourseDetailPage(data: openedCourse).show(context);
          }
          break;
        case "profile":
          if (UserLoginStatusController().isLogin()) {
            ///フレンド
            await Future.delayed(Duration(seconds: 1));
            ProfileData sharedUserData = await UserService().requestUserDataByUID(content);
            UserProfileAllInfoBottomSheet(userData: sharedUserData).show(context);
          }
          break;
      }
    }
  }

  Map<String, String>? parseUrl(String url) {
    // 更新正則表達式以處理 Scheme 和路徑
    final regex = RegExp(r'universal-link\.directsense\.tw[:\/]+([^\/]+)\/([^\/]+)');
    final match = regex.firstMatch(url);

    if (match != null) {
      final type = match.group(1);
      final id = match.group(2);
      return {'type': type!, 'content': id!};
    }
    return null;
  }
}

// ignore_for_file: avoid_print

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/home/userPage/my_notification_page/course/my_notification_course_page.dart';
import '../components/home/userPage/my_notification_page/my_notification_post_page.dart';
import '../components/home/userPage/my_notification_page/my_notification_proflie_page.dart';
import '../global.dart';
import '../global/home_global_view_model.dart';
import '../global/user_login_status_controller.dart';
import '../pageManager/enum/bottom_bar_path.dart';

class BaseShareUrlHandle {
  final BuildContext context;
  final WidgetRef ref;

  BaseShareUrlHandle({required this.context, required this.ref});

  Future<void> runShareUrl(Uri url) async {
    Map<String, String>? mappedData = parseUrl("$url");

    if (mappedData != null && !ref.read(notifiProfilePageIsOpen.notifier).state) {
      String type = mappedData["type"] ?? "";
      String content = mappedData["content"] ?? "";

      switch (type) {
        case "post":
          if (UserLoginStatusController().isLogin()) {
            ///文章
            HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.home);

            MyNotificationPostPage(postId: content).show(context);
          }
          break;
        case "course":
          if (UserLoginStatusController().isLogin()) {
            ///コース
            HomeGlobalViewModel().popUntiltFirstThentoPage(BottomBarPath.course);

            MyNotificationCourseDetailPage(courseId: content).show(context);
          }
          break;
        case "profile":
          if (UserLoginStatusController().isLogin()) {
            ///フレンド
            MyNotificationProfilePage(userUId: content).show(context);
          }
          break;
      }
      ref.read(notifiProfilePageIsOpen.notifier).update((state) => true);
    }
  }

  Map<String, String>? parseUrl(String url) {
    final regex = RegExp(r'skillstorm\.directsense\.tw[:\/]+([^\/]+)\/([^\/]+)');
    final match = regex.firstMatch(url);

    if (match != null) {
      final type = match.group(1);
      final id = match.group(2);
      return {'type': type!, 'content': id!};
    }
    return null;
  }
}

class IOSNativeSchemeUrlService {
  late BuildContext context;
  late WidgetRef ref;

  late BaseShareUrlHandle baseShareUrlHandle;

  Future<void> init({required BuildContext context, required WidgetRef ref}) async {
    baseShareUrlHandle = BaseShareUrlHandle(context: context, ref: ref);
    const platform = MethodChannel('iosNativeSchemeUrlHandle');

    try {
      this.context = context;
      this.ref = ref;

      platform.setMethodCallHandler(_handleMethod);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (call.method == "handleUrl") {
      String url = call.arguments;

      if (url != "") {
        Uri uri = Uri.parse(url);
        baseShareUrlHandle.runShareUrl(uri);
      }
    }
  }
}

class AppLinkService {
  late BuildContext context;
  late WidgetRef ref;

  final appLinks = AppLinks();
  late BaseShareUrlHandle baseShareUrlHandle;

  Future<void> init({required BuildContext context, required WidgetRef ref}) async {
    baseShareUrlHandle = BaseShareUrlHandle(context: context, ref: ref);

    try {
      this.context = context;
      this.ref = ref;

      IOSNativeSchemeUrlService().init(context: context, ref: ref);

      Uri? uri = await appLinks.getInitialLink();

      print("AppLinks Init");
      if (uri != null) {
        baseShareUrlHandle.runShareUrl(uri);
      }

      applinkListen();
    } catch (e) {
      print(e);
    }
  }

  void applinkListen() {
    appLinks.uriLinkStream.listen((event) {
      baseShareUrlHandle.runShareUrl(event);
    });
  }
}

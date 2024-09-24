// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_change_page.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/provider/home/skill_change_view_provider.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';
import 'package:social_mediam_match/services/user_service.dart';
import '../components/utilities/endDrawers/chat_room_end_drawer.dart';
import '../global.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../provider/corse_view_model.dart';
import '../provider/course_provider.dart';
import '../provider/friend_provider.dart';
import '../provider/post/post_comment_provider.dart';
import '../provider/post/post_view_model.dart';
import '../services/course_service.dart';
import '../services/dynamic_links.dart';
import '../services/firebase_notification_service.dart';
import '../services/post_service.dart';
import 'enum/bottom_bar_path.dart';
import 'setting/bottom_bar_controller_provider.dart';
import 'setting/bottom_bar_manager.dart';
import '../components/utilities/apiListView/base_api_list_provider.dart';
import '../components/home/postPage/post_page_forum.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PostProvider()),
          ChangeNotifierProvider(create: (_) => PostCommentProvider()),
        ],
        child: const PostPageForum(),
      ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SkillChangeProvider()),
          ChangeNotifierProvider(create: (_) => BaseAPIListProvider<LoginUser>()),
        ],
        child: const SkillChangePage(),
      ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CourseProvider()),
          ChangeNotifierProvider(create: (_) => SkillChangeProvider()),
          ChangeNotifierProvider(create: (_) => BaseAPIListProvider<CourseModel>()),
        ],
        child: const CoursePage(),
      ),
      const FirendsPage(),
      const UserPage(),
    ];

    return StatefulWrapper(
      onInit: () async {
        if (Platform.isAndroid) {
          //初始化 > dynamicLink 在上架前,先暫時只有安卓使用
          DynamicLinks().initDynamicLink(context);
          //初始化 > 通知系統 在上架前,先暫時只有安卓使用
          FirebaseNotificationService notificationService = FirebaseNotificationService()
            ..initNotification(context, notificationOnChangePage);
          notificationService.notificationListen(getNotReadNotificationCount: () {
            context.read<UserProvider>().getNotificationCount();
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: widgetOptions[context.watch<BottomBarControllerProvider>().index],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: bottomBarItems,
          currentIndex: context.watch<BottomBarControllerProvider>().index,
          selectedItemColor: Colors.amber[800],
          onTap: (value) {
            BottomBarPath choicedPath = BottomBarPath.home;
            for (var element in BottomBarPath.values) {
              if (element.path == value) {
                choicedPath = element;
              }
            }
            context.read<BottomBarControllerProvider>().bottomBarPageChange(choicedPath);
          },
        ),
      ),
    );
  }

  ///取得した通知でページ遷移関数
  Future<void> notificationOnChangePage(int pathIndex, int? postId, int? courseId, int? roomId, String? userUID) async {
    BottomBarPath path = BottomBarPath.home;
    if (pathIndex == 0) {
      path = BottomBarPath.home;
    } else if (pathIndex == 1) {
      path = BottomBarPath.course;
    } else if (pathIndex == 2) {
      path = BottomBarPath.my;
    } else if (pathIndex == 3) {
      path = BottomBarPath.chatRoom;
    }
    context.read<UserProvider>().getNotificationCount();
    context.read<BottomBarControllerProvider>().bottomBarPageChange(path);

    await Future.delayed(const Duration(seconds: 1));

    if (pathIndex == 0) {
      PostModel choicedPost = await PostService().getPostDataByPostId(postId ?? -1);
      PostViewModel(postContext: postContext ?? context).postDetailInit(choicedPost: choicedPost);
    } else if (pathIndex == 1) {
      CourseModel openedCourse = await CourseService().getCourseBycourseId(courseId ?? -1);
      CourseViewModel(courseContext: courseContext ?? context).courseDetailInit(openedCourse: openedCourse);
    } else if (pathIndex == 3) {
      LoginUser sendMsgUser = await UserService().requestGetUserData(userUID ?? "-1");
      context.read<FriendProvider>().openRoom(roomId ?? -1, sendMsgUser);
      openChatRoomEndDrawer(context: context);
    }
  }
}

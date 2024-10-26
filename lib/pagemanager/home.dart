import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import '../components/home/postPage/post_main_page.dart';
import '../components/home/skillExChangePage/skill_user_change_page.dart';
import '../components/utilities/style/theme_style.dart';
import '../global/global_view_model.dart';
import 'setting/bottom_navigation_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    ThemeStyle().init(ref);
    GlobalViewModel().init(ref, () => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> mainPage = [
      const PostMainPage(),
      const SkillUserChangePage(),
      const CourseMainPage(),
      Container(),
      Container(),
    ];

    return Stack(
      children: [
        mainPage[ref.watch(bottomNavigationBarProvider)],
        AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          bottom: ref.read(bottomNavationBarPosProvider.notifier).state,
          child: const BottomBar(),
        ),
      ],
    );
  }
}

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   void initState() {
//     globalHomeContext = context;
//     if (Platform.isAndroid) {
//       //初始化 > dynamicLink 在上架前,先暫時只有安卓使用
//       DynamicLinks().initDynamicLink(context);
//       //初始化 > 通知系統 在上架前,先暫時只有安卓使用
//       FirebaseNotificationService notificationService = FirebaseNotificationService()
//         ..initNotification(context, notificationOnChangePage);
//       notificationService.notificationListen(getNotReadNotificationCount: () {
//         context.read<UserProvider>().getNotificationCount();
//       });
//     }

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> widgetOptions = <Widget>[
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => PostProvider()),
//           ChangeNotifierProvider(create: (_) => PostCommentProvider()),
//         ],
//         child: const PostPageForum(),
//       ),
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => SkillChangeProvider()),
//           ChangeNotifierProvider(create: (_) => BaseAPIListProvider<ProfileData>()),
//         ],
//         child: const SkillChangePage(),
//       ),
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => CourseProvider()),
//           ChangeNotifierProvider(create: (_) => SkillChangeProvider()),
//           ChangeNotifierProvider(create: (_) => BaseAPIListProvider<CourseModel>()),
//         ],
//         child: const CoursePage(),
//       ),
//       const FirendsPage(),
//       const UserPage(),
//     ];

//     return Scaffold(
//       body: Stack(
//         children: [
//           widgetOptions[context.watch<BottomBarControllerProvider>().index],
//           AnimatedPositioned(
//             bottom: context.read<BottomBarControllerProvider>().bottomPosition,
//             duration: const Duration(milliseconds: 300),
//             child: const BottomNavationBar(),
//           ),
//           Center(
//             child: ElevatedButton(
//               onPressed: context.read<BottomBarControllerProvider>().moveBottomNavBar,
//               child: Text('Move Bottom Navigation Bar'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   ///取得した通知でページ遷移関数
//   Future<void> notificationOnChangePage(int pathIndex, int? postId, int? courseId, int? roomId, String? userUID) async {
//     BottomBarPath path = BottomBarPath.home;
//     if (pathIndex == 0) {
//       path = BottomBarPath.home;
//     } else if (pathIndex == 1) {
//       path = BottomBarPath.course;
//     } else if (pathIndex == 2) {
//       path = BottomBarPath.my;
//     } else if (pathIndex == 3) {
//       path = BottomBarPath.chatRoom;
//     }
//     context.read<UserProvider>().getNotificationCount();
//     context.read<BottomBarControllerProvider>().bottomBarPageChange(path);

//     await Future.delayed(const Duration(seconds: 1));

//     if (pathIndex == 0) {
//       PostModel choicedPost = await PostService().getPostDataByPostId(postId ?? -1);
//       PostViewModel(context: globalPostContext ?? context).postDetailInit(choicedPost: choicedPost);
//     } else if (pathIndex == 1) {
//       ProfileData userData = context.read<UserProvider>().userData;
//       CourseModel openedCourse = await CourseService().getCourseBycourseId(userData.uid, courseId ?? -1);
//       CourseViewModel(courseContext: courseContext ?? context).courseDetailInit(openedCourse: openedCourse);
//     } else if (pathIndex == 3) {
//       ProfileData sendMsgUser = await UserService().requestGetUserData(userUID ?? "-1");
//       context.read<FriendProvider>().openRoom(roomId ?? -1, sendMsgUser);
//       openChatRoomEndDrawer(context: context);
//     }
//   }
// }

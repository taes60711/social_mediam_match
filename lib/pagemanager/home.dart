import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/custom_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../components/home/firendsPage/firends_page.dart';
import '../components/home/userPage/user_page.dart';
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
    GlobalViewModel.init(ref, () => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> mainPage = [
      const PostMainPage(),
      const Scaffold(
        backgroundColor: Color.fromARGB(255, 29, 28, 28),
      ),
      const Scaffold(
        backgroundColor: Color.fromARGB(255, 29, 28, 28),
      ),
      const FirendsPage(),
      const UserPage(),
    ];

    return Stack(
      children: [
        mainPage[ref.watch(bottomNavigationBarProvider)],
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: ref.read(bottomNavationBarPosProvider.notifier).state,
          child: const BottomBar(),
        ),
      ],
    );
  }
}

class PostMainPage extends ConsumerStatefulWidget {
  const PostMainPage({super.key});

  @override
  ConsumerState<PostMainPage> createState() => _PostMainPageState();
}

bool topPostExpansion = false;

class _PostMainPageState extends ConsumerState<PostMainPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: topPostExpansion ? 95 : 40,
                ),
                Container(
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          GlobalViewModel().bottomBarHideStateChage(true);
                        },
                        child: Text("hide"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          GlobalViewModel().bottomBarHideStateChage(false);
                        },
                        child: Text("display"),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            BaseEndDrawer().show(context);
                          },
                          child: Text("drawer"),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            BaseBottomSheet().show(context);
                          },
                          child: Text("sheet"),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "123",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "123",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "123",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 80,
                  color: const Color.fromARGB(255, 37, 37, 37),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 80,
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 80,
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 150,
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 100,
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 100,
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 100,
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
                Container(
                  width: ScreenSize.width,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 100,
                  color: Color.fromARGB(255, 37, 37, 37),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            top: topPostExpansion ? 6 : 0,
            left: topPostExpansion ? 10 : 0,
            right: topPostExpansion ? 10 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: topPostExpansion ? 80 : 40,
              decoration: topPostExpansion
                  ? BoxDecoration(
                      color: const Color.fromARGB(255, 54, 54, 54),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : const BoxDecoration(
                      color: Color.fromARGB(255, 54, 54, 54),
                    ),
              child: Row(
                children: [
                  Expanded(
                    child: topPostExpansion
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hot!",
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text(
                                  "打造高效工作環境的五個關鍵策略asdasdasdasasdsa",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 1),
                                  width: ScreenSize.width,
                                  height: .5,
                                  color: Colors.grey,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "作成者:",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "asdasdsa",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                "Hot!",
                                style: TextStyle(color: Colors.red),
                              ),
                              SizedBox(width: 5),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  "打造高效工作環境的五個關鍵策略asdasdasdasasdsa",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                              ),
                            ],
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      topPostExpansion = !topPostExpansion;
                      setState(() {});
                    },
                    child: topPostExpansion
                        ? const Icon(
                            FontAwesomeIcons.angleUp,
                            size: 15,
                            color: Color.fromARGB(255, 95, 95, 95),
                          )
                        : const Icon(
                            FontAwesomeIcons.angleDown,
                            size: 15,
                            color: Color.fromARGB(255, 95, 95, 95),
                          ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
            ),
          )
        ],
      ),
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
//           ChangeNotifierProvider(create: (_) => BaseAPIListProvider<LoginUser>()),
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
//       LoginUser userData = context.read<UserProvider>().userData;
//       CourseModel openedCourse = await CourseService().getCourseBycourseId(userData.uid, courseId ?? -1);
//       CourseViewModel(courseContext: courseContext ?? context).courseDetailInit(openedCourse: openedCourse);
//     } else if (pathIndex == 3) {
//       LoginUser sendMsgUser = await UserService().requestGetUserData(userUID ?? "-1");
//       context.read<FriendProvider>().openRoom(roomId ?? -1, sendMsgUser);
//       openChatRoomEndDrawer(context: context);
//     }
//   }
// }

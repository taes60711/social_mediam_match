import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import '../components/home/firendsPage/firends_page.dart';
import '../components/home/postPage/post_main_page.dart';
import '../components/home/skillExChangePage/skill_user_change_page.dart';

import '../components/home/userPage/user_page.dart';

import '../global/home_global_view_model.dart';
import '../provider/account/user_provider.dart';
import '../provider/friend/chat_ws_model.dart';
import 'setting/bottom_navigation_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    HomeGlobalViewModel().init(
      context: context,
      ref: ref,
      render: () => setState(() {}),
    );

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    /// app 最小化 >　App戻る >　チャットルームリストWS もう一回繋がる
    if (state == AppLifecycleState.resumed) {
      /// チャットルームリストWS初始化
      ChatWSModel().init(ref, () => setState(() {}), userId: ref.watch(loginUserData).uid);

      print("Component Home: App resumed from background");
    }

    /// app 最小化 > チャットルームリストWS クローズ
    if (state == AppLifecycleState.paused) {
      /// チャットルームリストWS クローズ
      ChatWSModel().closeStream();

      print("Component Home: App paused");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> mainPage = [
      const PostMainPage(),
      const SkillUserChangePage(),
      const CourseMainPage(),
      const FriendPage(),
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/Account/login_page.dart';
import 'package:social_mediam_match/pageManager/home.dart';
import 'package:social_mediam_match/services/skill_service.dart';

import '../../models/post_model.dart';
import '../../models/skill_model.dart';
import '../../models/user_model.dart';
import '../../provider/account/user_provider.dart';

import '../../provider/friend/chat_ws_model.dart';
import '../../provider/post/post_provider.dart';
import '../../services/post_service.dart';
import '../../services/user_service.dart';
import '../utilities/style/theme_style.dart';
import 'splash_screen.dart';

final allSkillListData = StateProvider<List<RequestSkillListData>>((ref) => []);

final loginedUserUID = StateProvider<String>((ref) => "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2");

class Initialpage extends ConsumerStatefulWidget {
  const Initialpage({super.key});

  @override
  ConsumerState<Initialpage> createState() => _InitialpageState();
}

class _InitialpageState extends ConsumerState<Initialpage> {
  bool isFirst = false;
  bool initFinish = false;
  bool isLoginCheckFinish = false;

  @override
  void initState() {
    splashStart();
    allFuncinit();
    loginCheck();

    super.initState();
  }

  Future<void> splashStart() async {
    await Future.delayed(const Duration(seconds: 3));
    isFirst = true;
    setState(() {});
  }

  Future<void> allFuncinit() async {
    await Future.delayed(Duration.zero);
    ThemeStyle().init(ref);

    /// request All Skill
    List<RequestSkillListData> requestListData = await SkillService().requestSkillList();
    ref.read(allSkillListData.notifier).update((state) => requestListData);

    /// request TopPost
    List<PostModel> topPosts = await PostService().getPostByType(0, 3, -1);
    ref.read(topPostProvider.notifier).update((state) => topPosts);

    /// request All PostBoard
    List<PostBoard> allPostBoard = await PostService().getAllPostBoard();
    ref.read(allPostBoardListData.notifier).update((state) => allPostBoard);

    initFinish = true;
    setState(() {});
  }

  Future<void> loginCheck() async {
    if (userIsLogined()) {
      /// ユーザデータ取得
      ProfileData requestUserData = await UserService().requestGetUserData(ref.read(loginedUserUID));

      ref.read(loginUserData.notifier).update((state) => requestUserData);

      /// チャットルームWS初始化
      ChatWSModel().init(ref, () => setState(() {}), userId: ref.watch(loginUserData).uid);
    }

    isLoginCheckFinish = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget component = splashScreen(context);
    if (isFirst && initFinish && isLoginCheckFinish) {
      if (userIsLogined()) {
        component = const Home();
      } else {
        component = const LoginPage();
      }
    }

    return component;
  }

  bool userIsLogined() {
    return ref.read(loginedUserUID) != "";
  }
}

// Future<void> _enterApp(BuildContext context) async {
//   print("firstEnterApp");

//   // ユーザの資料を取得、最後ログインのタイム更新、友達リスト（WS）繋がる
//   context.read<UserProvider>().isLoginCheck(context);
// }

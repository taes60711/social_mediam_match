import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/pageManager/home.dart';
import 'package:social_mediam_match/services/skill_service.dart';
import '../../global/chat_ws_model.dart';

import '../../models/post_model.dart';
import '../../models/skill_model.dart';
import '../../models/user_model.dart';
import '../../provider/account/user_provider.dart';

import '../../provider/post/post_provider.dart';
import '../../services/post_service.dart';
import '../utilities/style/theme_style.dart';
import 'splash_screen.dart';

final allSkillListData = StateProvider<List<RequestSkillListData>>((ref) => []);

class Initialpage extends ConsumerStatefulWidget {
  const Initialpage({super.key});

  @override
  ConsumerState<Initialpage> createState() => _InitialpageState();
}

class _InitialpageState extends ConsumerState<Initialpage> {
  bool isFirst = false;
  bool initFinish = false;

  @override
  void initState() {
    splashStart();
    allFuncinit();

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

    /// ユーザデータ取得
    ProfileData userData = ref.watch(loginUserData);

    /// チャットルームWS初始化
    ChatWSModel().init(userData.uid);

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

  @override
  Widget build(BuildContext context) {
    Widget component = splashScreen(context);
    if (isFirst && initFinish) {
      component = const Home();
    }

    return component;
  }
}

Future<void> _enterApp(BuildContext context) async {
  print("firstEnterApp");

  // ユーザの資料を取得、最後ログインのタイム更新、友達リスト（WS）繋がる
  context.read<UserProvider>().isLoginCheck(context);
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/lodaing_dialog.dart';

import 'package:social_mediam_match/global/user_login_status_controller.dart';
import 'package:social_mediam_match/global/shared_preference.dart';
import 'package:social_mediam_match/pageManager/home.dart';
import 'package:social_mediam_match/services/skill_service.dart';

import '../../models/post_model.dart';
import '../../models/skill_model.dart';

import '../../provider/post/post_provider.dart';
import '../../services/post_service.dart';

import '../account/account_main_page.dart';

import '../utilities/style/theme_style.dart';
import 'splash_screen.dart';

final allSkillListData = StateProvider<List<RequestSkillListData>>((ref) => []);

class Initialpage extends ConsumerStatefulWidget {
  const Initialpage({super.key});

  @override
  ConsumerState<Initialpage> createState() => _InitialpageState();
}

class _InitialpageState extends ConsumerState<Initialpage> {
  bool isSplashFinish = false;
  bool initFinish = false;
  bool isLoginCheckFinish = false;

  @override
  void initState() {
    splashStart();
    allFuncinit();

    super.initState();
  }

  Future<void> splashStart() async {
    await Future.delayed(const Duration(seconds: 3));
    isSplashFinish = true;

    print("splashStart Finish");
    setState(() {});
  }

  Future<void> allFuncinit() async {
    await Future.delayed(Duration.zero);

    LoadingDialog().init(context);

    /// sharedPreference 初期化
    await SharedPreference().init();

    ///ログインステータスチュック
    await _loginCheck();

    ///　テーマ初期化
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

    print("allFuncinit Finish");
    setState(() {});
  }

  ///ログインステータスチュック
  Future<void> _loginCheck() async {
    /// ログインステータス初期化
    await UserLoginStatusController().init(
      initRef: ref,
      initRender: () => setState(() {}),
      initSharedPreference: SharedPreference(),
    );

    isLoginCheckFinish = true;
    print("loginCheck Finish");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget component = splashScreen(context);
    if (isSplashFinish && initFinish && isLoginCheckFinish) {
      if (UserLoginStatusController().isLogin()) {
        component = const Home();
      } else {
        component = const AccountMainPage();
      }
    }

    return component;
  }
}

// Future<void> _enterApp(BuildContext context) async {
//   print("firstEnterApp");

//   // ユーザの資料を取得、最後ログインのタイム更新、友達リスト（WS）繋がる
//   context.read<UserProvider>().isLoginCheck(context);
// }

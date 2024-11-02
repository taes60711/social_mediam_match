import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/pageManager/home.dart';
import 'package:social_mediam_match/services/skill_service.dart';
import '../../global/chat_ws_model.dart';

import '../../models/skill_model.dart';
import '../../models/user_model.dart';
import '../../provider/account/user_provider.dart';
import '../../provider/Initial/initial_provider.dart';

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

  @override
  void initState() {
    ThemeStyle().init(ref);

    Future.delayed(Duration.zero).then((value) async {
      ProfileData userData = ref.watch(loginUserData);
      ChatWSModel().init(userData.uid);

      /// request All Skill
      List<RequestSkillListData> requestListData = await SkillService().requestSkillList();
      ref.read(allSkillListData.notifier).update((state) => requestListData);
    });
    Future.delayed(const Duration(seconds: 3)).then((_) {
      isFirst = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget component = splashScreen(context);
    if (isFirst) {
      component = const Home();
    }

    return component;
  }
}

Future<void> _enterApp(BuildContext context) async {
  print("firstEnterApp");
  int delayTime = 3;

  // ユーザの資料を取得、最後ログインのタイム更新、友達リスト（WS）繋がる
  context.read<UserProvider>().isLoginCheck(context);

  Timer(Duration(seconds: delayTime), () {
    context.read<InitialProvider>().onChange();
  });
}

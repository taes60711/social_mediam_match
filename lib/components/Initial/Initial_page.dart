import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/pageManager/home.dart';
import '../../global/chat_ws_model.dart';
import '../../models/user_model.dart';
import '../../provider/account/user_provider.dart';
import '../../provider/Initial/initial_provider.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';
import '../utilities/style/theme_style.dart';

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

    Future.delayed(Duration.zero).then((value) {
      ProfileData userData = ref.watch(loginUserData);
      ChatWSModel().init(userData.uid);
    });
    Future.delayed(const Duration(seconds: 3)).then((_) {
      isFirst = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isfirstEnterApp = context.select((InitialProvider value) => value.isfirstEnterApp);
    // ProfileData userData = context.watch<UserProvider>().userData;
    // bool isLoginLoading = context.select((UserProvider value) => value.isLoading);

    // Widget component;

    // ///MARK: テスト用

    // if (isfirstEnterApp) {
    //   component = splashScreen(context);
    // } else {
    //   if (isLoginLoading) {
    //     component = const Scaffold(
    //       backgroundColor: Colors.white,
    //       body: Loading(),
    //     );
    //   } else {
    //     if (userData.uid != "-1") {
    //       component = const ProviderScope(
    //         child: Home(),
    //       );
    //     } else {
    //       component = const WelcomePage();
    //     }
    //   }
    // }

    Widget component = splashScreen(context);
    if (isFirst) {
      component = const Home();
    }

    return component;
  }
}

Widget splashScreen(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.whiteColor,
    body: Center(
      child: SizedBox(
        width: ScreenSize.width,
        child: AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: Image.asset(logoImg),
        ),
      ),
    ),
  );
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

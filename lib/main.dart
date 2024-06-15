import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/CustomBouncingScrollPhysics.dart';
import 'package:social_mediam_match/firebase_options.dart';
import 'package:social_mediam_match/global.dart';
import 'pageManager/provider/bottom_bar_controller_provider.dart';

import 'pageManager/setting/route_manager.dart';
import 'provider/account/user_provider.dart';

import 'states/friend_state.dart';
import 'states/skill_exchange_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BottomBarControllerProvider()),
        ChangeNotifierProvider(create: (_) => FriendState(channelListUrl: channelListUrl)),
        ChangeNotifierProvider(create: (_) => SkillExChangeState()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('zh', 'TW'), Locale('en', 'US'), Locale('ja', 'JP')],
        fallbackLocale: const Locale('en', 'US'),
        path: 'assets/langs',
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        physics: const CustomBouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
      theme: ThemeData(
        fontFamily: 'GenJyu',
        useMaterial3: false,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        }),
      ),
      routes: routeManager,
    );
  }
}

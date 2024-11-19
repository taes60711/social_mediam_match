// ignore_for_file: unused_import

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/CustomBouncingScrollPhysics.dart';

import 'package:social_mediam_match/firebase_options.dart';
import 'package:social_mediam_match/global.dart';
import 'components/Initial/Initial_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('zh', 'TW')], //const [Locale('zh', 'TW'), Locale('en', 'US'), Locale('ja', 'JP')],
      fallbackLocale: const Locale('zh', 'TW'), //const Locale('en', 'US'),
      path: 'assets/langs',
      child: const ProviderScope(
        child: MyApp(),
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
        physics: const NoBouncingScrollPhysics(),
      ),
      theme: ThemeData(
        fontFamily: 'GenJyu',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
        useMaterial3: false,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        }),
      ),
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => const Initialpage(),
      },
    );
  }
}

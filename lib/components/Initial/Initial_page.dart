import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/home.dart';
import 'package:social_mediam_match/components/Initial/logo.dart';
import 'package:social_mediam_match/state/initialState.dart';
import 'package:social_mediam_match/state/userState.dart';

class Initialpage extends StatelessWidget {
  const Initialpage({super.key});

  @override
  Widget build(BuildContext context) {
    int delayTime = 1;
    bool _isfirstEnterApp =
        context.select((InitialState value) => value.isfirstEnterApp);

    enterApp() {
      context.read<UserState>().isLoginCheck();
      Timer(Duration(seconds: delayTime), () {
        context.read<InitialState>().onChange();
      });
    }

    enterApp();

    return Scaffold(
      body: _isfirstEnterApp ? const Logo() : Home(),
    );
  }
}

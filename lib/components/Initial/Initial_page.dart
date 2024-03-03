import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/home.dart';
import 'package:social_mediam_match/components/Initial/logo.dart';
import 'package:social_mediam_match/states/initial_state.dart';
import 'package:social_mediam_match/states/user_state.dart';

import '../../models/user_model.dart';

class Initialpage extends StatelessWidget {
  const Initialpage({super.key});

  @override
  Widget build(BuildContext context) {
    int delayTime = 1;
    bool isfirstEnterApp = context.select((InitialState value) => value.isfirstEnterApp);
    LoginUser? userData = context.select((UserState value) => value.userData);
    void enterApp() {
      context.read<UserState>().isLoginCheck();
      Timer(Duration(seconds: delayTime), () {
        context.read<InitialState>().onChange();
      });
    }

    enterApp();

    return Scaffold(
      body: isfirstEnterApp
          ? const Logo()
          : Home(
              userData: userData,
            ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/home.dart';
import 'package:social_mediam_match/components/Initial/logo.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/states/initial_state.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../models/user_model.dart';

class Initialpage extends StatelessWidget {
  const Initialpage({super.key});

  @override
  Widget build(BuildContext context) {
    int delayTime = 1;
    bool isfirstEnterApp = context.select((InitialState value) => value.isfirstEnterApp);
    LoginUser? userData = context.select((UserState value) {
      if (value.userData != null) {
        return LoginUser(
          uid: value.userData!.uid,
          email: value.userData!.email,
          isEmailVerified: value.userData!.isEmailVerified,
          name: value.userData!.name,
          introduction: value.userData!.introduction,
          mainSkills: value.userData!.mainSkills,
          wantSkills: value.userData!.wantSkills,
        );
      } else {
        return null;
      }
    });
    void enterApp() {
      print("first");
      context.read<UserState>().isLoginCheck();
      Timer(Duration(seconds: delayTime), () {
        context.read<InitialState>().onChange();
      });
    }

    return Scaffold(
      body: isfirstEnterApp
          ? StatefulWrapper(
              onInit: () => enterApp(),
              child: const Logo(),
            )
          : Home(userData: userData),
    );
  }
}

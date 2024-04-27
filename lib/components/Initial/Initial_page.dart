import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/welcome_page.dart';
import 'package:social_mediam_match/components/home/home.dart';
import 'package:social_mediam_match/components/Initial/logo.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/initial_state.dart';
import 'package:social_mediam_match/states/user_state.dart';
import '../../models/user_model.dart';

class Initialpage extends StatelessWidget {
  const Initialpage({super.key});

  @override
  Widget build(BuildContext context) {
    int delayTime = 3;

    bool isfirstEnterApp = context.select((InitialState value) => value.isfirstEnterApp);
    FriendState friendState = context.select((FriendState value) => value);
    LoginUser? userData = context.select((UserState value) {
      if (value.userData != null) {
        return LoginUser(
          uid: value.userData!.uid,
          token: value.userData!.token,
          image: value.userData!.image,
          email: value.userData!.email,
          isEmailVerified: value.userData!.isEmailVerified,
          name: value.userData!.name,
          job: value.userData!.job,
          lastLogin: value.userData!.lastLogin,
          status: value.userData!.status,
          introduction: value.userData!.introduction,
          mainSkills: value.userData!.mainSkills,
          wantSkills: value.userData!.wantSkills,
        );
      } else {
        return null;
      }
    });

    bool isLoading = context.select((UserState value) => value.isLoading);
    void enterApp() {
      print("firstEnterApp");
      context.read<UserState>().isLoginCheck(friendState);
      Timer(Duration(seconds: delayTime), () {
        context.read<InitialState>().onChange();
      });
    }

    Widget component;
    if (isfirstEnterApp) {
      component = StatefulWrapper(
        onInit: () => enterApp(),
        child: const Logo(),
      );
    } else {
      if (isLoading) {
        component = const Scaffold(
          body: Loading(),
        );
      } else {
        if (userData != null) {
          component = Home(
            userData: userData,
            friendState: friendState,
          );
        } else {
          component = const WelcomePage();
        }
      }
    }

    return component;
  }
}

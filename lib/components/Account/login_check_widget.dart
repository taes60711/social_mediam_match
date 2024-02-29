import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/config.dart';
import 'package:social_mediam_match/states/user_state.dart';
import 'package:social_mediam_match/utilities/screen_size.dart';

class LoginCheckWidget extends StatelessWidget {
  final Widget component;
  const LoginCheckWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    String userData = context.select((UserState value) => value.userData);
    Widget userComponent;

    Widget RequireLogin() {
      return SizedBox(
        width: ScreenSize().width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("目前沒有登入,請登入或註冊帳戶"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Path.loginPage.value,
                );
              },
              child: Text("進入登入頁面"),
            ),
          ],
        ),
      );
    }

    if (userData == "") {
      userComponent = RequireLogin();
    } else {
      userComponent = component;
    }
    return userComponent;
  }
}

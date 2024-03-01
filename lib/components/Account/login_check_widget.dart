import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/user_state.dart';
import 'package:social_mediam_match/utilities/screen_size.dart';

class LoginCheckWidget extends StatelessWidget {
  final Widget component;
  const LoginCheckWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    UserLoginModel? userData = context.select((UserState value) => value.userData);
    Widget userComponent;

    Widget RequireLogin() {
      return SizedBox(
        width: ScreenSize().width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("目前沒有登入,請登入或註冊帳戶"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  RoutePath.loginPage.value,
                );
              },
              child: const Text("進入登入頁面"),
            ),
          ],
        ),
      );
    }

    if (userData == null) {
      userComponent = RequireLogin();
    } else {
      userComponent = component;
    }
    return userComponent;
  }
}

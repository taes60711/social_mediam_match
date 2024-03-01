import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/strings/login_chek_widget_string.dart';
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

    Widget requireLogin() {
      return SizedBox(
        width: ScreenSize().width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(noUserData),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  RoutePath.loginPage.value,
                );
              },
              child: Text(enterLoginButton),
            ),
          ],
        ),
      );
    }

    if (userData == null) {
      userComponent = requireLogin();
    } else {
      userComponent = component;
    }
    return userComponent;
  }
}

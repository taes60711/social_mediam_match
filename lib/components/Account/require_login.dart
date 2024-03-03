import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/strings/login_chek_widget_string.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class LoginCheckWidget extends StatelessWidget {
  const LoginCheckWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../global.dart';
import '../utilities/style/screen_size.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: ScreenSize().height / 8, bottom: ScreenSize().height / 3.5),
            width: 180,
            height: 180,
            child: Image.asset('assets/Logo.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: Color.fromRGBO(246, 138, 89, 1),
              borderRadius: BorderRadius.circular(15.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(15.0),
                onTap: () {
                  Navigator.of(context).pushNamed(RoutePath.signUpPage.value);
                },
                child: Container(
                  width: ScreenSize().width,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "第一次使用",
                      style: TextStyle(color: Color.fromARGB(255, 243, 239, 231)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: disAbleColor,
              borderRadius: BorderRadius.circular(15.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(15.0),
                onTap: () {
                  Navigator.of(context).pushNamed(RoutePath.loginPage.value);
                },
                child: Container(
                  width: ScreenSize().width,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "登入",
                      style: TextStyle(color: normalBgColor2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text("登出"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              "ver 1.0.0",
              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 177, 176, 176)),
            ),
          ),
        ],
      )),
    );
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/states/user_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    String signError = context.select((UserState value) => value.signError);
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    emailController.text = "taes60811@gmail.com";
    pwdController.text = "toto60811";

    void ReturnLoginPage() {
      resetAllInfo() {
        userFuture.signError = SignUpStatus.NoMessage.value;
      }

      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.loginPage.value));
      resetAllInfo();
    }

    Widget signErrorMessage;
    if (signError != SignUpStatus.NoMessage.value) {
      signErrorMessage = Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            signError,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      signErrorMessage = Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("註冊帳戶"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.email,
                  size: 36,
                ),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.lock,
                  size: 36,
                ),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: pwdController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          signErrorMessage,
          ElevatedButton(
            onPressed: () async {
              String email = emailController.text;
              String pwd = pwdController.text;
              log("signUpPage Email:$email Pwd:$pwd");
              bool isSignSucess = await userFuture.signUp(email, pwd);
              isSignSucess ? ReturnLoginPage() : () {};
            },
            child: const Text("註冊"),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 20,
                      height: 1,
                      color: Colors.black45,
                    ),
                  ),
                  const Text("或"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 20,
                      height: 1,
                      color: Colors.black45,
                    ),
                  ),
                ],
              )),
          ElevatedButton(
            onPressed: () {
              log("Google 登入");
            },
            child: const Text("Google 登入"),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              log("Twitter 登入");
            },
            child: const Text("Twitter 登入"),
          ),
        ],
      ),
    );
  }
}

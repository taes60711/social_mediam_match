import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/states/user_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    emailController.text = "taes60811@gmail.com";
    pwdController.text = "toto60811";
    return Scaffold(
      appBar: AppBar(
        title: Text("註冊帳戶"),
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
          ElevatedButton(
            onPressed: () async {
              String email = emailController.text;
              String pwd = pwdController.text;
              log("signUpPage Email:$email Pwd:$pwd");
              await userFuture.signUp(email, pwd);
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
